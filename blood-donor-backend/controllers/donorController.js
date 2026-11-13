const db = require('../models');
const Donor = db.Donor;
const ExcelJS = require('exceljs');

// Register Donor
exports.registerDonor = async (req, res) => {
  try {
    const { name, age, bloodGroup, contact, city, email } = req.body;
    const donor = await Donor.create({ name, age, bloodGroup, contact, city, email });
    res.status(201).json({ message: 'Donor registered', donor });
  } catch (err) {
    res.status(400).json({ error: 'Donor registration failed', details: err });
  }
};

// Get all donors
exports.getAllDonors = async (req, res) => {
  try {
    const donors = await Donor.findAll();
    res.json(donors);
  } catch (err) {
    res.status(500).json({ error: 'Error fetching donors' });
  }
};

// Search donors
exports.searchDonors = async (req, res) => {
  const { bloodGroup, city } = req.query;
  try {
    const donors = await Donor.findAll({
      where: {
        ...(bloodGroup && { bloodGroup }),
        ...(city && { city }),
      },
    });
    res.json(donors);
  } catch (err) {
    res.status(500).json({ error: 'Search failed', details: err });
  }
};

// Export donors to Excel
exports.exportDonorsToExcel = async (req, res) => {
  try {
    const donors = await Donor.findAll();
    const workbook = new ExcelJS.Workbook();
    const sheet = workbook.addWorksheet('Donors');

    sheet.columns = [
      { header: 'ID', key: 'id', width: 5 },
      { header: 'Name', key: 'name', width: 25 },
      { header: 'Age', key: 'age', width: 10 },
      { header: 'Blood Group', key: 'bloodGroup', width: 15 },
      { header: 'Contact', key: 'contact', width: 20 },
      { header: 'City', key: 'city', width: 20 },
      { header: 'Email', key: 'email', width: 30 },
    ];

    donors.forEach(d => sheet.addRow(d.toJSON()));

    res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    res.setHeader('Content-Disposition', 'attachment; filename=donors.xlsx');

    await workbook.xlsx.write(res);
    res.end();
  } catch (err) {
    res.status(500).json({ error: 'Excel export failed', details: err });
  }
};
