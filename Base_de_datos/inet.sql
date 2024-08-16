-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 16-08-2024 a las 05:25:51
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `inet`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `cliente`
--

CREATE TABLE `cliente` (
  `id_cliente` int(11) NOT NULL,
  `id_persona_cliente` int(11) DEFAULT NULL,
  `direccion` text DEFAULT NULL,
  `telefono` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `cliente`
--

INSERT INTO `cliente` (`id_cliente`, `id_persona_cliente`, `direccion`, `telefono`) VALUES
(2, 4, 'Rafael del riego 1667', 2147483647),
(4, 6, 'Albert Einstein', 2147483647);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `id_factura` int(11) NOT NULL,
  `id_cliente_factura` int(11) DEFAULT NULL,
  `id_pedido_factura` int(11) DEFAULT NULL,
  `id_metodo_pago_factura` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `metodo_pago`
--

CREATE TABLE `metodo_pago` (
  `id_metodo_pago` int(11) NOT NULL,
  `nombre` text DEFAULT NULL,
  `descripcion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido`
--

CREATE TABLE `pedido` (
  `id_pedido` int(11) NOT NULL,
  `id_cliente_pedido` int(11) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `estado` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedido_entregado`
--

CREATE TABLE `pedido_entregado` (
  `id_pedido_entregado` int(11) NOT NULL,
  `id_pedido_entregado_fk` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE `persona` (
  `id_persona` int(11) NOT NULL,
  `nombre` varchar(40) NOT NULL,
  `apellido` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`id_persona`, `nombre`, `apellido`) VALUES
(3, 'Juan', 'Pablo'),
(4, 'Lautaro', 'Aguirre'),
(5, 'Juan', 'Gutierrez'),
(6, 'Hernan', 'James'),
(9, 'Ignacio', 'Sanchez');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `id_producto` int(11) NOT NULL,
  `nombre` text DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `precio_unitario` float DEFAULT NULL,
  `cantidad_existente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`id_producto`, `nombre`, `descripcion`, `precio_unitario`, `cantidad_existente`) VALUES
(1, 'Balón de fútbol', 'Balón de fútbol oficial de tamaño 5', 30, 50),
(2, 'Raqueta de tenis', 'Raqueta de tenis profesional de fibra de carbono', 120, 20),
(3, 'Bicicleta de montaña', 'Bicicleta de montaña con suspensión completa', 450, 15),
(4, 'Camiseta deportiva', 'Camiseta de deporte transpirable y de secado rápido', 25, 100);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `renglon_producto`
--

CREATE TABLE `renglon_producto` (
  `id_renglon` int(11) NOT NULL,
  `id_pedido_renglon` int(11) DEFAULT NULL,
  `id_producto_renglon` int(11) DEFAULT NULL,
  `cantidad_vender` int(11) DEFAULT NULL,
  `subtotal` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tarjeta`
--

CREATE TABLE `tarjeta` (
  `id_tarjeta` int(11) NOT NULL,
  `id_cliente_tarjeta` int(11) DEFAULT NULL,
  `id_metodo_tarjeta` int(11) DEFAULT NULL,
  `nombre` text DEFAULT NULL,
  `tipo` text DEFAULT NULL,
  `numero` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `id_persona_usuario` int(11) DEFAULT NULL,
  `email` text DEFAULT NULL,
  `contraseña` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `id_persona_usuario`, `email`, `contraseña`) VALUES
(1, 4, 'aguirrerico52@gmail.com', 'lauchita8'),
(2, 5, 'jjajajajaja@gmail.com', 'jajaja'),
(3, 6, 'aaaaaa@gmail.com', 'lalalala'),
(6, 9, 'nachito@gmail.com', 'nacho123');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id_cliente`),
  ADD KEY `id_persona_cliente` (`id_persona_cliente`);

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`id_factura`),
  ADD KEY `id_cliente_factura` (`id_cliente_factura`),
  ADD KEY `id_pedido_factura` (`id_pedido_factura`),
  ADD KEY `id_metodo_pago_factura` (`id_metodo_pago_factura`);

--
-- Indices de la tabla `metodo_pago`
--
ALTER TABLE `metodo_pago`
  ADD PRIMARY KEY (`id_metodo_pago`);

--
-- Indices de la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`id_pedido`),
  ADD KEY `id_cliente_pedido` (`id_cliente_pedido`);

--
-- Indices de la tabla `pedido_entregado`
--
ALTER TABLE `pedido_entregado`
  ADD PRIMARY KEY (`id_pedido_entregado`),
  ADD KEY `id_pedido_entregado_fk` (`id_pedido_entregado_fk`);

--
-- Indices de la tabla `persona`
--
ALTER TABLE `persona`
  ADD PRIMARY KEY (`id_persona`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id_producto`);

--
-- Indices de la tabla `renglon_producto`
--
ALTER TABLE `renglon_producto`
  ADD PRIMARY KEY (`id_renglon`),
  ADD KEY `id_pedido_renglon` (`id_pedido_renglon`),
  ADD KEY `id_producto_renglon` (`id_producto_renglon`);

--
-- Indices de la tabla `tarjeta`
--
ALTER TABLE `tarjeta`
  ADD PRIMARY KEY (`id_tarjeta`),
  ADD KEY `id_metodo_tarjeta` (`id_metodo_tarjeta`),
  ADD KEY `id_cliente_tarjeta` (`id_cliente_tarjeta`);

--
-- Indices de la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`),
  ADD KEY `id_persona_U` (`id_persona_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `factura`
--
ALTER TABLE `factura`
  MODIFY `id_factura` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `metodo_pago`
--
ALTER TABLE `metodo_pago`
  MODIFY `id_metodo_pago` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pedido`
--
ALTER TABLE `pedido`
  MODIFY `id_pedido` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `pedido_entregado`
--
ALTER TABLE `pedido_entregado`
  MODIFY `id_pedido_entregado` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `persona`
--
ALTER TABLE `persona`
  MODIFY `id_persona` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `renglon_producto`
--
ALTER TABLE `renglon_producto`
  MODIFY `id_renglon` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `tarjeta`
--
ALTER TABLE `tarjeta`
  MODIFY `id_tarjeta` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`id_persona_cliente`) REFERENCES `persona` (`id_persona`);

--
-- Filtros para la tabla `factura`
--
ALTER TABLE `factura`
  ADD CONSTRAINT `factura_ibfk_1` FOREIGN KEY (`id_cliente_factura`) REFERENCES `cliente` (`id_cliente`),
  ADD CONSTRAINT `factura_ibfk_2` FOREIGN KEY (`id_pedido_factura`) REFERENCES `pedido` (`id_pedido`),
  ADD CONSTRAINT `factura_ibfk_3` FOREIGN KEY (`id_metodo_pago_factura`) REFERENCES `metodo_pago` (`id_metodo_pago`);

--
-- Filtros para la tabla `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `pedido_ibfk_1` FOREIGN KEY (`id_cliente_pedido`) REFERENCES `cliente` (`id_cliente`);

--
-- Filtros para la tabla `pedido_entregado`
--
ALTER TABLE `pedido_entregado`
  ADD CONSTRAINT `pedido_entregado_ibfk_1` FOREIGN KEY (`id_pedido_entregado_fk`) REFERENCES `pedido` (`id_pedido`);

--
-- Filtros para la tabla `renglon_producto`
--
ALTER TABLE `renglon_producto`
  ADD CONSTRAINT `renglon_producto_ibfk_1` FOREIGN KEY (`id_pedido_renglon`) REFERENCES `pedido` (`id_pedido`),
  ADD CONSTRAINT `renglon_producto_ibfk_2` FOREIGN KEY (`id_producto_renglon`) REFERENCES `producto` (`id_producto`);

--
-- Filtros para la tabla `tarjeta`
--
ALTER TABLE `tarjeta`
  ADD CONSTRAINT `tarjeta_ibfk_1` FOREIGN KEY (`id_metodo_tarjeta`) REFERENCES `metodo_pago` (`id_metodo_pago`),
  ADD CONSTRAINT `tarjeta_ibfk_2` FOREIGN KEY (`id_cliente_tarjeta`) REFERENCES `cliente` (`id_cliente`);

--
-- Filtros para la tabla `usuario`
--
ALTER TABLE `usuario`
  ADD CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`id_persona_usuario`) REFERENCES `persona` (`id_persona`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
