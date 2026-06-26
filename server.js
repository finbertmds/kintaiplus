import { exec } from "child_process";
import express from "express";

const app = express();

app.use(express.json());


app.get("/clock-in", (req, res) => {
  console.log("Clock in time: " + new Date().toLocaleString("ja-JP", { timeZone: "Asia/Tokyo" }));
  exec(
    "npm run clock_in",
    (error, stdout, stderr) => {

      if (error) {
        console.error(error);

        return res.status(500).json({
          success: false,
          error: error.message
        });
      }

      res.json({
        success: true,
        output: stdout
      });

    }
  );

});


app.get("/clock-out", (req, res) => {
  console.log("Clock out time: " + new Date().toLocaleString("ja-JP", { timeZone: "Asia/Tokyo" }));
  exec(
    "npm run clock_out",
    (error, stdout) => {

      if (error) {
        return res.status(500).json({
          success:false
        });
      }


      res.json({
        success:true,
        output:stdout
      });

    }
  );

});


app.listen(3000, () => {
  console.log("server running :3000");
});
