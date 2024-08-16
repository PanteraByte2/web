import express from 'express';
import bodyParser from 'body-parser';
import session from 'express-session';
import path from 'path';
import { fileURLToPath } from 'url';
import { MercadoPagoConfig, Preference } from 'mercadopago';
import conexion from './conexion.js'; // Importar conexión de la base de datos

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();

// Configurar Mercado Pago
const client = new MercadoPagoConfig({ accessToken: 'APP_USR-1273616427086786-081416-6c677cf05d5375601b97d922415fb61c-1947370360' });

// Configurar body-parser para manejar datos del formulario
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

// Configuración de sesiones
app.use(session({
    secret: 'mi-secreto', // Cambia esto por un valor más seguro
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } // Cambia a true si usas HTTPS
}));

// Servir archivos estáticos desde la carpeta 'public'
app.use(express.static(path.join(__dirname, '..')));

// Página de inicio con opciones para registrarse o iniciar sesión
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, '..', 'index.html'));
});

// Renderizar el formulario de registro
app.get('/registro', (req, res) => {
    res.sendFile(path.join(__dirname, '..', 'secciones', 'formulario', 'registro.html'));
});

// Manejar el registro
app.post('/registro', (req, res) => {
    const { nombre, apellido, email, contraseña } = req.body;

    conexion.beginTransaction(err => {
        if (err) throw err;

        conexion.query(
            'SELECT id_persona_usuario FROM usuario WHERE email = ?',
            [email],
            (err, results) => {
                if (err) {
                    return conexion.rollback(() => {
                        throw err;
                    });
                }

                if (results.length > 0) {
                    return res.send(`
                        <p>Este email ya está registrado.</p>
                        <a href="/login">Inicia sesión aquí</a>
                    `);
                }

                conexion.query(
                    'INSERT INTO persona (nombre, apellido) VALUES (?, ?)',
                    [nombre, apellido],
                    (err, result) => {
                        if (err) {
                            return conexion.rollback(() => {
                                throw err;
                            });
                        }

                        const personaId = result.insertId;

                        conexion.query(
                            'INSERT INTO usuario (id_persona_usuario, email, contraseña) VALUES (?, ?, ?)',
                            [personaId, email, contraseña],
                            (err, result) => {
                                if (err) {
                                    return conexion.rollback(() => {
                                        throw err;
                                    });
                                }

                                conexion.commit(err => {
                                    if (err) {
                                        return conexion.rollback(() => {
                                            throw err;
                                        });
                                    }

                                    res.redirect(`/login`);
                                });
                            }
                        );
                    }
                );
            }
        );
    });
});

// Renderizar el formulario de inicio de sesión
app.get('/login', (req, res) => {
    res.sendFile(path.join(__dirname, '..', 'secciones', 'formulario', 'login.html'));
});

// Manejar el inicio de sesión y verificar si el usuario es cliente
app.post('/usuario', (req, res) => {
    const { email, contraseña } = req.body;

    conexion.query(
        'SELECT p.id_persona, u.email, u.contraseña, c.id_cliente FROM usuario u JOIN persona p ON u.id_persona_usuario = p.id_persona LEFT JOIN cliente c ON c.id_cliente = p.id_persona WHERE u.email = ?',
        [email],
        (err, results) => {
            if (err) throw err;

            if (results.length === 0) {
                return res.send(`
                    <p>Usuario o contraseña incorrectos.</p>
                    <a href="/login">Inténtalo de nuevo</a>
                `);
            }

            const user = results[0];
            if (user.contraseña !== contraseña) {
                return res.send(`
                    <p>Contraseña incorrecta.</p>
                    <a href="/login">Inténtalo de nuevo</a>
                `);
            }

            req.session.clienteId = user.id_cliente; // Guardar el ID del cliente en la sesión
            res.sendFile(path.join(__dirname, '..', 'index.html'));
        }
    );
});

app.get('/usuario', (req, res) => {
    const id = req.session.clienteId;
    connection.query(
        'SELECT id_persona FROM usuario WHERE id_cliente= ?', [id],
        (err, results) => {
            if (err) throw err;

            if (results.length === 0) {
                return res.send(`
                    <p>Email o contraseña incorrectos.</p>
                    <a href="/login">Intenta de nuevo</a>
                `);
            }
            id_persona = results[0];
            connection.query(
                `SELECT * FROM usuario WHERE id= ?`, [id_persona], (err, results) => {
                    if (err) throw err;
                    const persona = results[0].persona;

                    req.session.user = {
                        email: persona.email,
                        id_usuario: persona.id_usuario
                    };
                }
            );

            res.sendFile(path.join(__dirname, '..', 'secciones', 'Usuario', 'Usuario.html'));
        }
    );
});

// Renderizar la página de productos
app.get('/productos', (req, res) => {
    conexion.query('SELECT * FROM producto', (err, productos) => {
        if (err) throw err;
        res.json(productos);
    });
});

app.get('/productos-pagina', (req, res) => {
    res.sendFile(path.join(__dirname, '..', 'secciones', 'producto', 'producto.html'));
});

// Manejar la creación de un nuevo pedido
app.post('/iniciar-pedido', (req, res) => {
    const clienteId = req.session.clienteId;

    if (!clienteId) {
        return res.status(401).send('No estás autenticado');
    }

    conexion.query(
        'INSERT INTO pedido (id_cliente_pedido, fecha, estado) VALUES (?, NOW(), "En proceso")',
        [clienteId],
        (err, result) => {
            if (err) throw err;
            req.session.id_pedido_actual = result.insertId; // Guardar el ID del pedido en la sesión
            res.json({ id_pedido: req.session.id_pedido_actual });
        }
    );
});

// Manejar la inserción de productos en el carrito (renglón de producto)
app.post('/agregar-al-carrito', (req, res) => {
    const { id_producto, cantidad } = req.body;
    const id_pedido = req.session.id_pedido_actual;

    if (!id_pedido) {
        return res.status(400).send('No hay un pedido en curso');
    }

    conexion.query(
        'INSERT INTO renglon_producto (id_pedido_renglon, id_producto_renglon, cantidad_vender, subtotal) VALUES (?, ?, ?, (SELECT precio_unitario FROM producto WHERE id_producto = ?) * ?)',
        [id_pedido, id_producto, cantidad, id_producto, cantidad],
        (err, result) => {
            if (err) throw err;
            res.json({ success: true });
        }
    );
});

// Manejar la finalización de la compra
app.post('/finalizar-compra', (req, res) => {
    const id_pedido_actual = req.session.id_pedido_actual;

    if (id_pedido_actual) {
        conexion.query(
            'UPDATE pedido SET estado = "Finalizado" WHERE id_pedido = ?',
            [id_pedido_actual],
            (err, result) => {
                if (err) throw err;
                req.session.id_pedido_actual = null; // Resetear el ID del pedido actual
                res.json({ success: true });
            }
        );
    } else {
        res.status(400).json({ error: 'No hay pedido en curso' });
    }
});

// Crear una preferencia de pago con Mercado Pago
app.post("/create_preference", async (req ,res)=> {
    try{
        const body = {
            items: [
                {
                title: req.body.title,
                quantity: Number(req.body.quantity),
                unit_price: Number(req.body.price),
                currency_id: "ARS",
                },
            ],
            back_urls: {
                success:"https://www.youtube.com/@onthecode",
                failure:"https://www.youtube.com/@onthecode",
                pending:"https://www.youtube.com/@onthecode ",
            },
            auto_return: "approved",
        };

        const preference = new Preference(client);
        const result = await preference.create({body});
        res.json({
            id: result.id,
        });
    }catch (error) {
        console.log(error)
        res.status(500).json({
            error: "Error al crear la preferencia"
        })
    }
});

// Escuchar en el puerto 3000
app.listen(3000, () => {
    console.log('Servidor iniciado en http://localhost:3000');
});
