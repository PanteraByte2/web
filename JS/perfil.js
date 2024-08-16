document.addEventListener('DOMContentLoaded', () => {
    fetch('/usuario')
        .then(response => response.json())
        .then(data => {
            const enlace = document.getElementById('inicio-sesion');

            // Modifica el contenido del enlace
            enlace.textContent = 'Mi Perfil';

            // Modifica el atributo href del enlace
            enlace.href = '/secciones/usuario/usuario.html';
        })
        .catch(error => console.error('Error:', error));
});