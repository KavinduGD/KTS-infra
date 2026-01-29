const express = require("express");
const { exec } = require("child_process");

const app = express();
app.use(express.json());

const SECRET = process.env.DEPLOY_SECRET;

app.post("/backend-deploy", (req, res) => {
  const token = req.headers["x-deploy-token"];

  if (token !== SECRET) {
    return res.status(403).send("Forbidden");
  }

  console.log("Deploy request received");

  exec("/app/scripts/backend-deploy.sh", (err, stdout, stderr) => {
    if (err) {
      console.error(stderr);
      return res.status(500).send("Deploy failed");
    }

    console.log(stdout);
    res.send("Deploy successful");
  });
});

app.post("/admin-deploy", (req, res) => {
  const token = req.headers["x-deploy-token"];

  if (token !== SECRET) {
    return res.status(403).send("Forbidden");
  }

  console.log("Deploy request received");

  exec("/app/scripts/admin-deploy.sh", (err, stdout, stderr) => {
    if (err) {
      console.error(stderr);
      return res.status(500).send("Deploy failed");
    }

    console.log(stdout);
    res.send("Deploy successful");
  });
});

app.post("/user-deploy", (req, res) => {
  const token = req.headers["x-deploy-token"];

  if (token !== SECRET) {
    return res.status(403).send("Forbidden");
  }

  console.log("Deploy request received");

  exec("/app/scripts/user-deploy.sh", (err, stdout, stderr) => {
    if (err) {
      console.error(stderr);
      return res.status(500).send("Deploy failed");
    }

    console.log(stdout);
    res.send("Deploy successful");
  });
});

app.listen(3000, () => {
  console.log("Webhook listening on port 3000");
});
