const express = require('express');
const router = express.Router();
const { verifyToken } = require('../middleware/authMiddleware');
const {
  registerDonor,
  getAllDonors,
  searchDonors,
  exportDonorsToExcel,
} = require('../controllers/donorController');

// Donor Registration (User)
router.post('/register', verifyToken, registerDonor);

// View All Donors (Admin)
router.get('/all', verifyToken, getAllDonors);

// Search Donors by Blood Group + City (Admin)
router.get('/search', verifyToken, searchDonors);

// Export to Excel (Admin)
router.get('/export', verifyToken, exportDonorsToExcel);

module.exports = router;
