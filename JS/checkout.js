// Configura Mercado Pago
const mp = new MercadoPago('APP_USR-405752fa-83cd-43b1-bd30-352314bc1954', {
    locale: "es-AR",
});

// Maneja el evento de clic en el botón de finalizar compra
document.getElementById("checkout-btn").addEventListener("click", async () => {
    try {
        const orderData = {
            title: document.querySelector(".name")?.innerText || 'Producto Genérico',
            quantity: 1,
            price: 100,
        };

        // Solicita la creación de una preferencia de pago en el servidor
        const response = await fetch("/create_preference", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(orderData),
        });

        const preference = await response.json();
        createCheckoutButton(preference.id);
    } catch (error) {
        alert("Error al procesar el pago.");
        console.error(error);
    }
});

// Crea el botón de pago con Mercado Pago
const createCheckoutButton = (preferenceId) => {
    const bricksBuilder = mp.bricks();

    const renderComponent = async () => {
        if (window.checkoutButton) {
            try {
                window.checkoutButton.unmount();
            } catch (error) {
                console.error("Error al desmontar el botón:", error);
            }
        }

        try {
            window.checkoutButton = await bricksBuilder.create("wallet", "wallet_container", {
                initialization: {
                    preferenceId: preferenceId,
                },
                customization: {
                    texts: {
                        valueProp: 'smart_option',
                    },
                },
            });
        } catch (error) {
            console.error("Error al crear el botón:", error);
        }
    };

    renderComponent();
};
