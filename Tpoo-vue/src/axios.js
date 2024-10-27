import axios from 'axios';

// Create an instance of axios
const apiClient = axios.create({
    baseURL: 'http://localhost:4000/api',  // Your Phoenix backend URL
    withCredentials: true, // This allows axios to send cookies (like JWT in HttpOnly)
    headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
    }
});

// Interceptor to add XSRF token to the headers of each request
apiClient.interceptors.request.use((config) => {
    const xsrfToken = localStorage.getItem('xsrf-token'); // Store XSRF token in localStorage after sign-in
    if (xsrfToken) {
        config.headers['X-XSRF-TOKEN'] = xsrfToken;
    }
    return config;
});

export default apiClient;
