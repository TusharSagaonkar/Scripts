import HabitCard from './HabitCard'

const HabitList = ({ habits, onDeleteHabit, onToggleCompletion }) => {
  const categories = [
    { value: 'health', label: '🏃 Health & Fitness', color: '#ff6b6b' },
    { value: 'learning', label: '📚 Learning & Growth', color: '#4ecdc4' },
    { value: 'productivity', label: '⚡ Productivity', color: '#45b7d1' },
    { value: 'mindfulness', label: '🧘 Mindfulness', color: '#96ceb4' },
    { value: 'social', label: '👥 Social', color: '#feca57' },
    { value: 'creative', label: '🎨 Creative', color: '#ff9ff3' },
    { value: 'other', label: '📝 Other', color: '#a29bfe' }
  ]

  if (habits.length === 0) {
    return (
      <div className="empty-state">
        <div className="empty-icon">🎯</div>
        <h3>No habits yet!</h3>
        <p>Start building better habits by creating your first one above.</p>
      </div>
    )
  }

  // Group habits by category
  const groupedHabits = habits.reduce((groups, habit) => {
    const category = habit.category || 'other'
    if (!groups[category]) {
      groups[category] = []
    }
    groups[category].push(habit)
    return groups
  }, {})

  return (
    <div className="habit-list">
      {Object.entries(groupedHabits).map(([categoryKey, categoryHabits]) => {
        const category = categories.find(cat => cat.value === categoryKey) || categories.find(cat => cat.value === 'other')
        
        return (
          <div key={categoryKey} className="category-section">
            <div className="category-header">
              <h3 style={{ color: category.color }}>
                {category.label}
              </h3>
              <span className="habit-count">
                {categoryHabits.length} habit{categoryHabits.length !== 1 ? 's' : ''}
              </span>
            </div>
            
            <div className="habits-grid">
              {categoryHabits.map(habit => (
                <HabitCard
                  key={habit.id}
                  habit={habit}
                  categoryColor={category.color}
                  onDelete={onDeleteHabit}
                  onToggleCompletion={onToggleCompletion}
                />
              ))}
            </div>
          </div>
        )
      })}
    </div>
  )
}

export default HabitList