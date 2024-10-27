const path = 'https://tpoo.onrender.com/api/workingtime'

// mobile = 10.0.2.2
// web = localhost:4000

export const getWorkingTimes = async (userId) => {
  try {
    const response = await fetch(`${path}/${userId}`)
    if (!response.ok) {
      throw new Error('Network response was not ok')
    }
    const data = await response.json()
    return data.data
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
    throw error
  }
}

export const getAWorkingTime = async (userId, workingTimeId) => {
  try {
    const response = await fetch(`${path}/${userId}/${workingTimeId}`)
    if (!response.ok) {
      throw new Error('Network response was not ok')
    }
    const data = await response.json()
    return data.data
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
    throw error
  }
}

export const addWorkingTime = async (workingTime, userId) => {
  try {
    const response = await fetch(`${path}/${userId}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify(workingTime)
    })
    if (!response.ok) {
      throw new Error('Network response was not ok')
    }
    const data = await response.json()
    return data.data
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
    throw error
  }
}

export const deleteWorkingTime = async (userId, workingTimeId) => {
  try {
    const response = await fetch(`${path}/${userId}/${workingTimeId}`, {
      method: 'DELETE'
    })
    if (!response.ok) {
      throw new Error('Network response was not ok')
    }

    const text = await response.text()
    const data = text ? JSON.parse(text) : null
    return data ? data.data : null
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
    throw error
  }
}

export const updateWorkingTime = async (userId, workingTimeId, updatedData) => {
  try {
    const response = await fetch(`${path}/${userId}/${workingTimeId}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ workingtime: updatedData })
    })
    if (!response.ok) {
      throw new Error('Network response was not ok')
    }
    const data = await response.json()
    return data.data
  } catch (error) {
    console.error('There was a problem with the fetch operation:', error)
    throw error
  }
}
