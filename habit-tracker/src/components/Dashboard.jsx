const Dashboard = ({ habits }) => {
  const getTotalCompletions = () => {
    return habits.reduce((total, habit) => total + habit.completions.length, 0)
  }

  const getActiveStreaks = () => {
    return habits.filter(habit => habit.streak > 0).length
  }

  const getBestPerformer = () => {
    if (habits.length === 0) return null
    return habits.reduce((best, current) => 
      current.streak > best.streak ? current : best
    )
  }

  const getCompletionToday = () => {
    const today = new Date().toDateString()
    return habits.filter(habit => habit.completions.includes(today)).length
  }

  const getCategoryStats = () => {
    const categories = {
      health: { name: '🏃 Health & Fitness', count: 0, completions: 0, color: '#ff6b6b' },
      learning: { name: '📚 Learning & Growth', count: 0, completions: 0, color: '#4ecdc4' },
      productivity: { name: '⚡ Productivity', count: 0, completions: 0, color: '#45b7d1' },
      mindfulness: { name: '🧘 Mindfulness', count: 0, completions: 0, color: '#96ceb4' },
      social: { name: '👥 Social', count: 0, completions: 0, color: '#feca57' },
      creative: { name: '🎨 Creative', count: 0, completions: 0, color: '#ff9ff3' },
      other: { name: '📝 Other', count: 0, completions: 0, color: '#a29bfe' }
    }

    habits.forEach(habit => {
      const category = habit.category || 'other'
      if (categories[category]) {
        categories[category].count++
        categories[category].completions += habit.completions.length
      }
    })

    return Object.entries(categories)
      .filter(([_, stats]) => stats.count > 0)
      .map(([key, stats]) => ({ key, ...stats }))
  }

  const getWeeklyProgress = () => {
    const days = []
    for (let i = 6; i >= 0; i--) {
      const date = new Date()
      date.setDate(date.getDate() - i)
      const dateString = date.toDateString()
      const dayName = date.toLocaleDateString('en-US', { weekday: 'short' })
      
      const completions = habits.reduce((count, habit) => {
        return count + (habit.completions.includes(dateString) ? 1 : 0)
      }, 0)

      days.push({
        day: dayName,
        date: dateString,
        completions,
        total: habits.length
      })
    }
    return days
  }

  const weeklyProgress = getWeeklyProgress()
  const categoryStats = getCategoryStats()
  const bestPerformer = getBestPerformer()

  if (habits.length === 0) {
    return (
      <div className="dashboard">
        <div className="empty-dashboard">
          <div className="empty-icon">📊</div>
          <h3>No data to display</h3>
          <p>Create some habits first to see your progress and statistics here!</p>
        </div>
      </div>
    )
  }

  return (
    <div className="dashboard">
      <div className="dashboard-header">
        <h2>📊 Your Progress Dashboard</h2>
        <p>Track your habit journey and celebrate your wins!</p>
      </div>

      <div className="stats-grid">
        <div className="stat-card">
          <div className="stat-icon">🎯</div>
          <div className="stat-content">
            <h3>{habits.length}</h3>
            <p>Total Habits</p>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon">✅</div>
          <div className="stat-content">
            <h3>{getTotalCompletions()}</h3>
            <p>Total Completions</p>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon">🔥</div>
          <div className="stat-content">
            <h3>{getActiveStreaks()}</h3>
            <p>Active Streaks</p>
          </div>
        </div>

        <div className="stat-card">
          <div className="stat-icon">📅</div>
          <div className="stat-content">
            <h3>{getCompletionToday()}/{habits.length}</h3>
            <p>Completed Today</p>
          </div>
        </div>
      </div>

      {bestPerformer && (
        <div className="best-performer">
          <h3>🏆 Best Performer</h3>
          <div className="performer-card">
            <h4>{bestPerformer.name}</h4>
            <p>{bestPerformer.streak} day streak!</p>
          </div>
        </div>
      )}

      <div className="weekly-chart">
        <h3>📈 Weekly Progress</h3>
        <div className="chart-container">
          {weeklyProgress.map(day => (
            <div key={day.date} className="day-bar">
              <div 
                className="bar"
                style={{ 
                  height: `${habits.length > 0 ? (day.completions / habits.length) * 100 : 0}%`,
                  backgroundColor: day.completions === habits.length ? '#4CAF50' : '#ff6b6b'
                }}
              />
              <span className="day-label">{day.day}</span>
              <span className="day-count">{day.completions}/{day.total}</span>
            </div>
          ))}
        </div>
      </div>

      {categoryStats.length > 0 && (
        <div className="category-breakdown">
          <h3>📋 Category Breakdown</h3>
          <div className="category-stats">
            {categoryStats.map(category => (
              <div key={category.key} className="category-stat">
                <div className="category-info">
                  <h4 style={{ color: category.color }}>{category.name}</h4>
                  <p>{category.count} habits • {category.completions} completions</p>
                </div>
                <div 
                  className="category-progress"
                  style={{ backgroundColor: category.color + '20' }}
                >
                  <div 
                    className="progress-fill"
                    style={{ 
                      width: `${Math.min((category.completions / (category.count * 30)) * 100, 100)}%`,
                      backgroundColor: category.color
                    }}
                  />
                </div>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  )
}

export default Dashboard