const express = require('express');
const { Pool } = require('pg');
const app = express();
app.use(express.json());

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

// 1. Salud (Ya vimos que funciona)
app.get('/health', async (req, res) => {
  try {
    const result = await pool.query('SELECT PostGIS_Full_Version();');
    res.json({ status: 'OK', postgis: result.rows[0].postgis_full_version });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 2. Ruta para que el celular del ayudante mande la ubicación
app.post('/update-location', async (req, res) => {
  const { driver_id, lat, lng } = req.body;
  try {
    const query = `
      UPDATE drivers 
      SET last_location = ST_SetSRID(ST_MakePoint($2, $1), 4326),
          updated_at = NOW()
      WHERE id = $3
    `;
    await pool.query(query, [lat, lng, driver_id]);
    res.json({ status: 'success', message: 'Ubicación actualizada en Pilar' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});


const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Servidor de fletes corriendo en puerto ${PORT}`);
});
