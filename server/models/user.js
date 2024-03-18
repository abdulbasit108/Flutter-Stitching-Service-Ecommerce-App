const mongoose = require("mongoose");
const { productSchema } = require("./product");
const { measurementSchema } = require("./measurement");

const userSchema = mongoose.Schema({
  name: {
    required: true,
    type: String,
    trim: true,
  }, 
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
     validator: (value) => {
       const re =
         /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
       return value.match(re);
     },
      message: "Please enter a valid email address",
    },
  },
  phone: {
    required: true,
    type: String,
    trim: true,
    //  validate: {
    //    validator: (value) => {
    //      const re = /^[0-9]{10}$/; // Regex for a 10-digit phone number
    //      return value.match(re);
    //    },
    //    message: "Please enter a valid phone number",
    //  },
  },
  address: [
    {
      addressLabel: {
        type: String,
        required: true,
        default: ''
      },
      addressData: {
        type: String,
        required: true,
        default: ''
      },
    },
  ],
  payment: [
    {
      paymentLabel: {
        type: String,
        required: true,
        default: ''
      },
      paymentData: {
        type: String,
        required: true,
        default: ''
      },
    },
  ],
  type: {
    type: String,
    default: "user",
  },
  cart: [
    {
      product: productSchema,
      profileData: measurementSchema,
      quantity: {
        type: Number,
        required: true,
      },
      neckStyle: {
        type: String,
        required: true,
      },
      sleeveStyle: {
        type: String,
        required: true,
      },
      trouserLength: {
        type: String,
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
      ]

      
    },
  ],
});

const User = mongoose.model("User", userSchema);
module.exports = User;