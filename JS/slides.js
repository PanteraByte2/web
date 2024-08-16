// Función para obtener los productos y construir los slides
async function cargarSlides() {
try {
    const response = await fetch('/productos');
    const productos = await response.json();
    const container = document.getElementById('slides-container');
    // Construye el HTML de los slides
    container.innerHTML = productos.map(producto => `
        <div class="swiper-slide">
            <h2>${producto.nombre}</h2>
            <p>${producto.descripcion}</p>
            <p>Precio: $${producto.precio_unitario}</p>
            <p>Cantidad: ${producto.cantidad_existente}</p>
        </div>
    `).join('');
    new Swiper('.swiper', {
        centeredSlides: true,
        slidesPerView: 'auto',    
        effect: 'coverflow',        
        pagination: {
            el:".swiper-pagination",
            clickable: true,
        },
        navigation: {
            nextEl: ".swiper-button-next",
            prevEl: ".swiper-button-prev",
        },
    });
    } catch (error) {
        console.error('Error al cargar los slides:', error);
    }
}

// Cargar los slides cuando se cargue la página
window.onload = cargarSlides;