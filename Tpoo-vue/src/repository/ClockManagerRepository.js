const path = 'http://localhost:4000/api/clocks'

// Fonction pour obtenir l'heure actuelle au format HH:mm:ss
export const getCurrentTime = () => {
    const date = new Date();
    return date.toLocaleTimeString();
}

// Fonction pour obtenir la date et l'heure actuelles au format YYYY-MM-DD HH:mm:ss
export const getCurrentDateTime = () => {
    const current = new Date();
    const date = `${current.getFullYear()}-${(current.getMonth() + 1).toString().padStart(2, '0')}-${current.getDate().toString().padStart(2, '0')}`;
    const time = `${current.getHours().toString().padStart(2, '0')}:${current.getMinutes().toString().padStart(2, '0')}:${current.getSeconds().toString().padStart(2, '0')}`;
    return `${date} ${time}`;
}

// Fonction pour gérer le pointage
export const save = async (clockData, userId) => {
    const time = getCurrentTime();

    try {
        const response = await fetch(`${path}/${userId}`,{
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(clockData)
        });
    } catch (err) {
        console.error("Erreur lors de la requête POST :", err);
    }
}
