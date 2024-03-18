
const express = require("express");
const mongoose = require("mongoose");


const adminRouter = require("./routes/admin");
const authRouter = require("./routes/auth");
const productRouter = require("./routes/product");
const userRouter = require("./routes/user");
const measurementRouter = require("./routes/measurement");


const PORT = process.env.PORT || 3000;
const app = express();
const DB =
  "mongodb+srv://cloudstitchpk:Z85d15SfMIp0mSRn@cluster0.jyg1nmz.mongodb.net/?retryWrites=true&w=majority";

app.use(express.json());
app.use(authRouter);
app.use(adminRouter);
app.use(productRouter);
app.use(userRouter);
app.use(measurementRouter)


mongoose
  .connect(DB)
  .then(() => {
    console.log("Connection Successful");
  })
  .catch((e) => {
    console.log(e);
  });

app.listen(PORT, "0.0.0.0", () => {
  console.log(`connected at port ${PORT}`);
});
