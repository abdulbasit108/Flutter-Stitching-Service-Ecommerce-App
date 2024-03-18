
const express = require("express");
const bodyparser = require('body-parser');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const mysql = require("mysql");

const accountSid = "";
const authToken = "";
const verifySid = "";
const client = require("twilio")(accountSid, authToken);

const connection = mysql.createConnection({
  host: "127.0.0.1",
  user: "root",
  password: "",
  database: "edarzi"
});

const app = express();
const PORT = process.env.PORT || 3000;

app.use(bodyparser.urlencoded({ extended: false }));
app.use(bodyparser.json());

connection.connect((error) => {
  if (error) {
    console.error("Database connection error: ", error);
    process.exit(1);
  } else {
    console.log("Connected to MySQL database");
  }
});

// SIGNUP API
app.post('/signup', async (req, res) => {
  const { name, email, phone } = req.body;

  const token = jwt.sign({ email: email }, 'your-secret-key');


// NODE MAILER TO GET SIGNUP CONFIRMATION
// Required your gmail credentials and have to give permission through gmail security
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

 transporter.sendMail(mailOptions, (error) => {
    if (error) {
      console.error('Failed to send welcome email:', error);
      res.status(500).json({ success: false, message: 'An error occurred during signup. Please try again later.' });
    } else {

      const signupSql = 'INSERT INTO users (name, email, phone) VALUES ( ?, ?, ?)';
      connection.query(signupSql, [name, email, phone], (error, signupResult) => {

        if (error) {
          console.error('Signup error:', error);
          res.status(500).json({ success: false, message: 'An error occurred during signup. Please try again later.' });
        } else {
//          res.status(200).json({ success: true, message: 'User Signed Up Successfully' });
//          const signupId = signupResult.insertId;
//          console.log('User signed up successfully. Signup ID:', signupId);
            const signupId = signupResult.insertId;
            console.log('User signed up successfully. Signup ID:', signupId);
            res.status(200).json({ success: true, message: 'User Signed Up Successfully'});
        }

      });
        }
        });

});

// Endpoint for sending verification code
app.post('/sendOTP', (req, res) => {
  const { phone } = req.body;

  // Check if the phone number exists in the database
  const selectQuery = 'SELECT * FROM users WHERE phone = ?';
  connection.query(selectQuery, [phone], (error, results) => {
    if (error) {
      console.error('Error finding user:', error);
      return res.status(500).json({ error: 'Failed to find user.' });
    }

    if (results.length === 0) {
      return res.status(400).json({ error: 'Phone number not found in the database.' });
    }

    client.verify
      .services(verifySid)
      .verifications.create({ to: phone, channel: 'sms' })
      .then((verification) => {
        console.log('Verification status:', verification.status);
        res.status(200).json({ message: 'Verification code sent successfully.' });
      })
      .catch((error) => {
        console.error('Error sending verification code:', error);
        res.status(500).json({ error: 'Failed to send verification code.' });
      });
  });
});

app.post('/verifyOTP', async (req, res) => {
  const {to, code} = req.body;

  try {
//  console.log(to,code);
    const verificationCheck = await client.verify
      .services(verifySid)
      .verificationChecks.create({code: code, to: to});

    console.log('OTP verification status:', verificationCheck.status);

    if (verificationCheck.status === 'approved') {
      res.status(200).json({ message: 'Verification successful.' });
    } else {
      res.status(400).json({ error: 'Invalid verification code.' });
    }

  }
  catch (error) {
    console.error('Error verifying OTP:', error);
        console.log('error');
        return false;
    res.status(500).json({ error: 'Failed to verify OTP.' });
  }
});


// **** MANUAL MEASUREMENT *****
app.post('/manualmeasurement', async (req, res) => {
  // ... existing code ...

  // Add the rest of your manualmeasurement code here
  const { mm_profile_name, mm_chest, mm_waist, mm_hips, mm_inseam, mm_sleeve, mm_shoulder } = req.body;

        const MeasurementSql = 'INSERT INTO manual_measurement (mm_profile_name, mm_chest, mm_waist, mm_hips, mm_inseam, mm_sleeve, mm_shoulder) VALUES ( ?, ?, ?, ?, ?, ?, ?)';
        connection.query(MeasurementSql, [mm_profile_name, mm_chest, mm_waist, mm_hips, mm_inseam, mm_sleeve, mm_shoulder], (error, signupResult) => {

          if (error) {
            console.error('Measurement error:', error);
            res.status(500).json({ success: false, message: 'An error occurred while saving the Measurement Profile. Please try again later.' });
          } else {
  //          res.status(200).json({ success: true, message: 'Measurement Profile Saved Successfully' });
            const MeasurementId = signupResult.insertId;
            console.log('Measurement Profile Saved Successfully. Profile ID:', MeasurementId);

          }

        });


});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
