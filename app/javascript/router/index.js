import { createRouter, createWebHistory } from 'vue-router';
import home from '../controllers/Home.vue';

const routes = [
    {
        path: '/',
        name: 'Home',
        component: home
    },
    // Agrega aquí tus rutas adicionales
];

const router = createRouter({
    history: createWebHistory(),
    routes
});

export default router;
