# Especificaciones Técnicas - App Agrobanco

| Vista | Componentes UI | Datos requeridos (API/local) | Interacciones clave | Estados offline | Prioridad |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Login** | Input (DNI), Input (Pass), Checkbox, Botones. | API: /auth/login. Local: DNI recordado. | Validación tiempo real, bloqueo tras 3 intentos. | Mensaje "Requiere conexión". | Alta |
| **Dashboard** | Cards (Saldos), Grid (Accesos), List (Movimientos). | API: /user/summary, /user/last-transactions. | Ocultar/Ver saldo, navegación rápida. | Mostrar banner "Última sincronización". | Alta |
| **Ahorros** | Tabs, Card (Balance), Botón (QR), Tabla. | API: /accounts, /accounts/{id}/history. | Generación de QR dinámico para depósitos. | Ver historial cacheado. | Alta |
| **Créditos** | Accordion (Créditos), Table (Cronograma), Floating Button. | API: /loans, /loans/{id}/schedule. | Expansión de cronograma, pago de cuotas. | Cronograma persistente en caché. | Alta |
| **Transferencias** | Tabs, Form, List (Favoritos), Modal (Confirm). | API: /transfers, /contacts. Local: Favoritos. | Selección de contacto, validación de PIN/Biometría. | Encolar transacción localmente. | Alta |
| **Perfil** | List, Toggles, Modal (Logout). | API: /user/profile, /user/security-settings. | Cambio de clave, activación de biometría. | Actualización local, sinc. diferida. | Media |