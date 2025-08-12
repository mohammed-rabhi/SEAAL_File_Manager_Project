const express = require("express");
const fs = require("fs");
const path = require("path");
const cors = require("cors");

const app = express();
const PORT = 3000;

// Directory where the files are stored
const FILES_DIR = path.join(__dirname, "files");

app.use(cors());
app.use(express.json());

// Make sure "files" folder exists
if (!fs.existsSync(FILES_DIR)) {
  fs.mkdirSync(FILES_DIR);
}

// 🔹 Auto-create 10 default files if missing
for (let i = 1; i <= 30; i++) {
  const filePath = path.join(FILES_DIR, `${i}-default.txt`);
  if (!fs.existsSync(filePath)) {
    fs.writeFileSync(filePath, `File ${i} - default`);
  }
}

// Helper to get the file path for a number and status
function getFilePath(num, status) {
  return path.join(FILES_DIR, `${num}-${status}.txt`);
}

/* ===========================
   1. LOAD (PC -> Smartphone)
   =========================== */
app.post("/load/:id", (req, res) => {
  const number = req.params.id;

  if (fs.existsSync(getFilePath(number, "decharge"))) {
    return res.json({ message: "File already unloaded" });
  }
  if (fs.existsSync(getFilePath(number, "charge"))) {
    return res.json({ message: "File already loaded" });
  }
  if (fs.existsSync(getFilePath(number, "default"))) {
    fs.renameSync(getFilePath(number, "default"), getFilePath(number, "charge"));
    return res.json({ message: `File ${number} loaded successfully` });
  }
  return res.json({ message: "File not found" });
});

/* =============================
   2. UNLOAD (Smartphone -> PC)
   ============================= */
app.post("/unload/:id", (req, res) => {
  const number = req.params.id;

  if (fs.existsSync(getFilePath(number, "charge"))) {
    fs.renameSync(getFilePath(number, "charge"), getFilePath(number, "decharge"));
    return res.json({ message: `File ${number} unloaded successfully` });
  }
  return res.json({ message: "No charged file found to unload" });
});

/* =============================
   3. STATUS (for Web + Mobile)
   ============================= */
app.get("/status", (req, res) => {
  const seen = new Set();
  const files = fs.readdirSync(FILES_DIR)
    .map(file => {
      const [num, status] = file.replace(".txt", "").split("-");
      return { id: num, status };
    })
    .filter(file => {
      if (seen.has(file.id)) return false;
      seen.add(file.id);
      return true;
    })
    .sort((a, b) => Number(a.id) - Number(b.id));

  res.json(files);
});

/* ===========================
   Start the server
   =========================== */
app.listen(PORT, () => {
  console.log(`✅ Server running on http://localhost:${PORT}`);
});
