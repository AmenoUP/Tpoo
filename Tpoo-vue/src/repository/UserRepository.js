const path = 'http://localhost:4000/api/users'

// mobile = 10.0.2.2
// web = localhost:4000

export async function fetchUserById(id) {
  try {
    const response = await fetch(`${path}/${id}`) // Utilisation de path ici
    if (!response.ok) {
      throw new Error("Erreur lors de la récupération de l'utilisateur")
    }
    const data = await response.json()
    console.log('Données récupérées :', data)
    return data // On renvoie directement les données reçues
  } catch (error) {
    console.error("Erreur lors de la récupération de l'utilisateur :", error)
    throw error // Propagation de l'erreur
  }
}

export async function fetchUsers() {
  try {
    const response = await fetch(`${path}`) // Utilisation de path ici
    if (!response.ok) {
      throw new Error('Erreur lors de la récupération des utilisateurs')
    }
    const data = await response.json()
    return data.data
  } catch (error) {
    console.error('Erreur :', error)
  }
}

export async function createUser(userData) {
  try {
    const response = await fetch(`${path}`, {
      // Utilisation de path ici
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(userData)
    })

    if (!response.ok) {
      throw new Error("Erreur lors de la création de l'utilisateur")
    }

    return await response.json()
  } catch (error) {
    console.error('Erreur :', error)
  }
}

export async function deleteUser(userId) {
  try {
    const response = await fetch(`${path}/${userId}`, {
      // Utilisation de path ici
      method: 'DELETE'
    })

    if (!response.ok) {
      throw new Error("Erreur lors de la suppression de l'utilisateur")
    }

    return await response.json()
  } catch (error) {
    console.error('Erreur lors de la suppression :', error)
  }
}

export async function updateUser(userId, updatedUserData) {
  try {
    const response = await fetch(`${path}/${userId}`, {
      // Utilisation de path ici
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(updatedUserData)
    })

    if (!response.ok) {
      throw new Error("Erreur lors de la mise à jour de l'utilisateur")
    }

    return await response.json()
  } catch (error) {
    console.error('Erreur lors de la mise à jour :', error)
  }
}
