const mongoose = require("mongoose");
const { productSchema } = require("./product");
const { measurementSchema } = require("./measurement");

const orderSchema = mongoose.Schema({
  products: [
    {
      product: productSchema,
      measurement: measurementSchema,
      quantity: {
        type: Number,
        required: true,
      },
      neckStyle: {
        type: Number,
        required: true,
      },
      sleeveStyle: {
        type: Number,
        required: true,
      },
      trouserLength: {
        type: Number,
        required: true,
      },
      instructions: {
        type: String,
        required: true,
        trim: true,
      },
      images: [
        {
          type: String,
          required: true,
        },
      ],
    },
  ],
  totalPrice: {
    type: Number,
    required: true,
  },
  isQuick: {
    type: Boolean,
    required: true,
  },
  address: {
    addressLabel: {
      type: String,
      required: true,
     
    },
    addressData: {
      type: String,
      required: true,
      
    },
  },
  payment: {
    paymentLabel: {
      type: String,
      required: true,
    },
    paymentData: {
      type: String,
      required: true,
    },
  },
  userId: {
    required: true,
    type: String,
  },
  orderedAt: {
    type: Number,
    required: true,
  },
});

const Order = mongoose.model("Order", orderSchema);
module.exports = Order;
