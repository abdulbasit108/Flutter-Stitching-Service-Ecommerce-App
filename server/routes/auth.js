const User = require("../models/user");
const express = require("express");
const authRouter = express.Router();
const jwt = require("jsonwebtoken");
const auth = require("../middlewares/auth");
const nodemailer = require('nodemailer');

const accountSid = "";
const authToken = "";
const verifySid = "";
const client = require("twilio")(accountSid, authToken);

// SIGN UP  
authRouter.post("/api/signup", async (req, res) => {
    try {
      const { name, email, phone } = req.body;

      const transporter = nodemailer.createTransport({
        service: 'gmail',
        auth: {
          user: '',
          pass: '',
        },
      });
    
      const mailOptions = {
          from: '',
          to: email,
          subject: 'Welcome to E DARZI',
          text: `Dear ${name},\n\nWelcome to E DARZI ! Thank you for Signing up. We are excited to have you on board.\n\nBest regards,\n E DARZI `,
        };
  
      const existingUser = await User.findOne({ email });
      if (existingUser) {
        return res
          .status(400)
          .json({ msg: "User with same email already exists!" });
      }

      transporter.sendMail(mailOptions, (error) => {
        if (error) {
          console.error('Failed to send welcome email:', error);
          return res.status(500).json({ msg: 'An error occurred during signup. Please try again later.' });
        } })
  
      let user = new User({
        email,
        phone,
        name,
      });
      user = await user.save();
      res.json(user);
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });


  authRouter.post("/api/sendOTP", async (req, res) => {
    try {
      const { phone } = req.body;
  
      const user = await User.findOne({ phone });
      if (!user) {
        return res
          .status(400)
          .json({ msg: "User with this phone does not exist!" });
      }

      client.verify.v2
      .services(verifySid)
      .verifications.create({ to: phone, channel: 'sms' })
      .then((verification) => {
        console.log('Verification status:', verification.status);
        res.status(200).json({ msg: 'Verification code sent successfully.' });
      })
      .catch((error) => {
        console.log('Error sending verification code:', error);
        res.status(500).json({ error: 'Failed to send verification code.' });
      });
  
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  });


authRouter.post("/api/signin", async (req, res) => {
  try {
    const { phone, code } = req.body;
    const user = await User.findOne({ phone });
    console.log(user);



    const verificationCheck = await client.verify
      .services(verifySid)
      .verificationChecks.create({code: code, to: phone});
    console.log(verificationCheck.status);
    if (verificationCheck.status === 'approved') {
      const token = jwt.sign({ id: user._id }, "passwordKey");
      res.json({ token, ...user._doc });
    } else {
      return res.status(400).json({ error: 'Invalid verification code.' });
    }

  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/tokenIsValid", async (req, res) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.json(false);
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.json(false);

    const user = await User.findById(verified.id);
    if (!user) return res.json(false);
    res.json(true);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// get user data
authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(req.user);
  res.json({ ...user._doc, token: req.token });
});

module.exports = authRouter;
