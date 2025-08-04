import { useState } from 'react'

const HabitCard = ({ habit, categoryColor, onDelete, onToggleCompletion }) => {
  const [showCalendar, setShowCalendar] = useState(false)
  
  const today = new Date().toDateString()
  const isCompletedToday = habit.completions.includes(today)
  
  // Get last 7 days for quick view
  const getLast7Days = () => {
    const days = []
    for (let i = 6; i >= 0; i--) {
      const date = new Date()
      date.setDate(date.getDate() - i)
      days.push({
        date: date.toDateString(),
        dayName: date.toLocaleDateString('en-US', { weekday: 'short' }),
        dayNum: date.getDate()
      })
    }
    return days
  }

  const last7Days = getLast7Days()

  const getCompletionRate = () => {
    const totalDays = Math.floor((new Date() - new Date(habit.createdAt)) / (1000 * 60 * 60 * 24)) + 1
    const completionRate = Math.round((habit.completions.length / totalDays) * 100)
    return Math.min(completionRate, 100)
  }

  return (
    <div className="habit-card">
      <div className="habit-header">
        <div className="habit-info">
          <h4 className="habit-name">{habit.name}</h4>
          {habit.description && (
            <p className="habit-description">{habit.description}</p>
          )}
        </div>
        <button 
          className="delete-btn"
          onClick={() => onDelete(habit.id)}
          title="Delete habit"
        >
          🗑️
        </button>
      </div>

      <div className="habit-stats">
        <div className="stat">
          <span className="stat-value">{habit.streak}</span>
          <span className="stat-label">Current Streak</span>
        </div>
        <div className="stat">
          <span className="stat-value">{habit.bestStreak}</span>
          <span className="stat-label">Best Streak</span>
        </div>
        <div className="stat">
          <span className="stat-value">{getCompletionRate()}%</span>
          <span className="stat-label">Completion Rate</span>
        </div>
      </div>

      <div className="habit-calendar">
        <div className="calendar-header">
          <span>Last 7 days</span>
          <button 
            className="toggle-calendar"
            onClick={() => setShowCalendar(!showCalendar)}
          >
            {showCalendar ? '📅' : '📊'}
          </button>
        </div>
        
        <div className="week-view">
          {last7Days.map(day => (
            <div 
              key={day.date}
              className={`day-cell ${habit.completions.includes(day.date) ? 'completed' : ''}`}
              onClick={() => onToggleCompletion(habit.id, day.date)}
              title={`${day.dayName} ${day.dayNum}`}
            >
              <span className="day-name">{day.dayName}</span>
              <span className="day-num">{day.dayNum}</span>
              {habit.completions.includes(day.date) && (
                <span className="checkmark">✓</span>
              )}
            </div>
          ))}
        </div>
      </div>

      <div className="habit-actions">
        <button 
          className={`complete-btn ${isCompletedToday ? 'completed' : ''}`}
          onClick={() => onToggleCompletion(habit.id)}
          style={{ 
            backgroundColor: isCompletedToday ? categoryColor : 'transparent',
            borderColor: categoryColor,
            color: isCompletedToday ? 'white' : categoryColor
          }}
        >
          {isCompletedToday ? '✓ Completed Today' : 'Mark Complete'}
        </button>
      </div>
    </div>
  )
}

export default HabitCard