const express = require("express");
const userRouter = express.Router();
const auth = require("../middlewares/auth");
const Order = require("../models/order");
const { Product } = require("../models/product");
const User = require("../models/user");
const { Measurement } = require("../models/measurement");

userRouter.post("/api/add-to-cart", auth, async (req, res) => {
  try {
    const { id, profile,trouserLength, 
       neckStyle, 
       sleeveStyle, 
       instructions, 
       images } = req.body;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);
    const profileData = await Measurement.findOne({ userId: req.user, profileName: profile });

    if (user.cart.length == 0) {
      user.cart.push({ product, quantity: 1 , profileData, trouserLength, 
        neckStyle, 
        sleeveStyle, 
        instructions, 
        images});
    } else {
      let isProductFound = false;
      for (let i = 0; i < user.cart.length; i++) {
        if (user.cart[i].product._id.equals(product._id)) {
          isProductFound = true;
        }
      }

      if (isProductFound) {
        let producttt = user.cart.find((productt) =>
          productt.product._id.equals(product._id)
        );
        producttt.quantity += 1;
      } else {
        user.cart.push({ product, quantity: 1 , profileData, trouserLength, 
          neckStyle, 
          sleeveStyle, 
          instructions, 
          images});
      }
    }
    user = await user.save();
    console.log(profileData)
    console.log(user.cart)
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.delete("/api/remove-from-cart/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
        
        if (user.cart[i].quantity == 1) {
          
          user.cart.splice(i, 1);
          
        } else {
          user.cart[i].quantity -= 1;
        }
      }
    }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.delete("/api/inc-quantity-cart/:id", auth, async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    let user = await User.findById(req.user);

    for (let i = 0; i < user.cart.length; i++) {
      if (user.cart[i].product._id.equals(product._id)) {
          user.cart[i].quantity += 1;
        }
      }
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


userRouter.post("/api/save-user-payment", auth, async (req, res) => {
  try {
    const { paymentLabel, paymentData } = req.body;
    let user = await User.findById(req.user);
    user.payment.push({paymentLabel, paymentData})
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.post("/api/save-user-address", auth, async (req, res) => {
  try {
    const { addressLabel, addressData } = req.body;
    let user = await User.findById(req.user);
    user.address.push({ addressLabel, addressData })
    user = await user.save();
    res.json(user);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// order product
userRouter.post("/api/order", auth, async (req, res) => {
  try {
    const { cart, totalPrice, addressLabel, paymentLabel, isQuick } = req.body;
    let products = [];
    let user = await User.findById(req.user);

    selectedAddress = user.address.find(address => address.addressLabel === addressLabel);
    selectedPayment = user.payment.find(payment => payment.paymentLabel === paymentLabel);

    
    

    for (let i = 0; i < cart.length; i++) {
      let product = await Product.findById(cart[i].product._id);
      if (product.quantity >= cart[i].quantity) {
        product.quantity -= cart[i].quantity;
        products.push({ 
          product, 
          quantity: cart[i].quantity, 
          measurement: cart[i].profileData, 
          neckStyle: cart[i].neckStyle,
          sleeveStyle: cart[i].sleeveStyle,
          trouserLength: cart[i].trouserLength,
          instructions: cart[i].instructions,
          images: cart[i].images

        });
        await product.save();
      } else {
        return res
          .status(400)
          .json({ msg: `${product.name} is out of stock!` });
      }
    }

    
    user.cart = [];
    user = await user.save();

    let order = new Order({
      products,
      totalPrice,
      isQuick,
      address: selectedAddress,
      payment: selectedPayment,
      userId: req.user,
      orderedAt: new Date().getTime(),
    });
    order = await order.save();
    res.json(order);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.get("/api/orders/me", auth, async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.user });
    console.log(orders)
    res.json(orders);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

module.exports = userRouter;
