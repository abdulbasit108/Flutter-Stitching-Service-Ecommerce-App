const mongoose = require("mongoose");

const measurementSchema = mongoose.Schema({
  profileName: {
    type: String,
    required: true,
  },
  chestMeasurement: {
    type: Number,
    required: true,
  },
  waistMeasurement: {
    type: Number,
    required: true,
  },
  hipsMeasurement: {
    type: Number,
    required: true,
  },
  inseamMeasurement: {
    type: Number,
    required: true,
  },
  sleeveMeasurement: {
    type: Number,
    required: true,
  },  
  shoulderMeasurement: {
    type: Number,
    required: true,
  },
  userId: {
    required: true,
    type: String,
  },
});

const Measurement = mongoose.model("Measurement", measurementSchema);
module.exports = { Measurement , measurementSchema };
