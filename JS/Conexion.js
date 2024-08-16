import mysql from 'mysql2';

// Crear la conexión a la base de datos
const conexion = mysql.createConnection({
    host: 'localhost',
    database: 'inet',
    user: 'root',
    password: ''
});

// Conectar a la base de datos
conexion.connect(err => {
    if (err) {
        console.error('Error al conectar a la base de datos:', err);
        process.exit(1);
    }
    console.log('Conexión a la base de datos establecida con éxito');
});

// Exportar la conexión
export default conexion;
