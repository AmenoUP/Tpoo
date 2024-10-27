const path = 'http://localhost:4000/api/tickets'

export async function fetchTicketById(id) {
  try {
    const response = await fetch(`${path}/${id}`)
    if (!response.ok) {
      throw new Error('Erreur lors de la récupération du ticket')
    }
    const data = await response.json()
    console.log('Données récupérées :', data)
    return data // On renvoie directement les données reçues
  } catch (error) {
    console.error('Erreur lors de la récupération du ticket :', error)
    throw error // Propagation de l'erreur
  }
}

export async function fetchTickets() {
  try {
    const response = await fetch(`${path}`)
    if (!response.ok) {
      throw new Error('Erreur lors de la récupération des tickets')
    }
    const data = await response.json()
    return data.data // On suppose que vos données sont dans un champ "data"
  } catch (error) {
    console.error('Erreur :', error)
  }
}

export async function createTicket(ticketData, userId) {
  try {
    // Wrap ticketData inside an object with the key "ticket"
    const payload = { ticket: ticketData }

    const response = await fetch(`${path}/${userId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(payload) // Send the wrapped payload
    })

    if (!response.ok) {
      throw new Error('Erreur lors de la création du ticket')
    }

    return await response.json()
  } catch (error) {
    console.error('Erreur :', error)
  }
}

export async function deleteTicketById(ticketId) {
  try {
    const response = await fetch(`${path}/${ticketId}`, {
      method: 'DELETE'
    })

    if (!response.ok) {
      throw new Error('Erreur lors de la suppression du ticket')
    }

    return await response.json() // On renvoie la réponse du serveur
  } catch (error) {
    console.error('Erreur lors de la suppression :', error)
  }
}
