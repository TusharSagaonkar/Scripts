import { useState } from 'react'

const HabitForm = ({ onAddHabit }) => {
  const [isFormOpen, setIsFormOpen] = useState(false)
  const [formData, setFormData] = useState({
    name: '',
    description: '',
    category: 'health',
    frequency: 'daily'
  })

  const categories = [
    { value: 'health', label: '🏃 Health & Fitness', color: '#ff6b6b' },
    { value: 'learning', label: '📚 Learning & Growth', color: '#4ecdc4' },
    { value: 'productivity', label: '⚡ Productivity', color: '#45b7d1' },
    { value: 'mindfulness', label: '🧘 Mindfulness', color: '#96ceb4' },
    { value: 'social', label: '👥 Social', color: '#feca57' },
    { value: 'creative', label: '🎨 Creative', color: '#ff9ff3' },
    { value: 'other', label: '📝 Other', color: '#a29bfe' }
  ]

  const frequencies = [
    { value: 'daily', label: 'Daily' },
    { value: 'weekly', label: 'Weekly' },
    { value: 'monthly', label: 'Monthly' }
  ]

  const handleSubmit = (e) => {
    e.preventDefault()
    if (formData.name.trim()) {
      onAddHabit(formData)
      setFormData({
        name: '',
        description: '',
        category: 'health',
        frequency: 'daily'
      })
      setIsFormOpen(false)
    }
  }

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value
    })
  }

  return (
    <div className="habit-form-container">
      {!isFormOpen ? (
        <button 
          className="add-habit-btn"
          onClick={() => setIsFormOpen(true)}
        >
          <span>+ Add New Habit</span>
        </button>
      ) : (
        <form className="habit-form" onSubmit={handleSubmit}>
          <div className="form-header">
            <h3>Create New Habit</h3>
            <button 
              type="button"
              className="close-btn"
              onClick={() => setIsFormOpen(false)}
            >
              ✕
            </button>
          </div>

          <div className="form-group">
            <label htmlFor="name">Habit Name *</label>
            <input
              type="text"
              id="name"
              name="name"
              value={formData.name}
              onChange={handleChange}
              placeholder="e.g., Drink 8 glasses of water"
              required
            />
          </div>

          <div className="form-group">
            <label htmlFor="description">Description</label>
            <textarea
              id="description"
              name="description"
              value={formData.description}
              onChange={handleChange}
              placeholder="Optional: Add more details about your habit..."
              rows="3"
            />
          </div>

          <div className="form-row">
            <div className="form-group">
              <label htmlFor="category">Category</label>
              <select
                id="category"
                name="category"
                value={formData.category}
                onChange={handleChange}
              >
                {categories.map(cat => (
                  <option key={cat.value} value={cat.value}>
                    {cat.label}
                  </option>
                ))}
              </select>
            </div>

            <div className="form-group">
              <label htmlFor="frequency">Frequency</label>
              <select
                id="frequency"
                name="frequency"
                value={formData.frequency}
                onChange={handleChange}
              >
                {frequencies.map(freq => (
                  <option key={freq.value} value={freq.value}>
                    {freq.label}
                  </option>
                ))}
              </select>
            </div>
          </div>

          <div className="form-actions">
            <button 
              type="button"
              className="cancel-btn"
              onClick={() => setIsFormOpen(false)}
            >
              Cancel
            </button>
            <button type="submit" className="submit-btn">
              Create Habit
            </button>
          </div>
        </form>
      )}
    </div>
  )
}

export default HabitForm