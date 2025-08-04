import { useState, useEffect } from 'react'
import './App.css'
import HabitForm from './components/HabitForm'
import HabitList from './components/HabitList'
import Dashboard from './components/Dashboard'

function App() {
  const [habits, setHabits] = useState([])
  const [activeTab, setActiveTab] = useState('habits')

  // Load habits from localStorage on app start
  useEffect(() => {
    const savedHabits = localStorage.getItem('habits')
    if (savedHabits) {
      setHabits(JSON.parse(savedHabits))
    }
  }, [])

  // Save habits to localStorage whenever habits change
  useEffect(() => {
    localStorage.setItem('habits', JSON.stringify(habits))
  }, [habits])

  const addHabit = (habit) => {
    const newHabit = {
      id: Date.now(),
      name: habit.name,
      description: habit.description,
      category: habit.category,
      frequency: habit.frequency,
      completions: [],
      createdAt: new Date().toISOString(),
      streak: 0,
      bestStreak: 0
    }
    setHabits([...habits, newHabit])
  }

  const deleteHabit = (id) => {
    setHabits(habits.filter(habit => habit.id !== id))
  }

  const toggleHabitCompletion = (id, date = new Date().toDateString()) => {
    setHabits(habits.map(habit => {
      if (habit.id === id) {
        const completions = [...habit.completions]
        const dateIndex = completions.indexOf(date)
        
        if (dateIndex > -1) {
          // Remove completion
          completions.splice(dateIndex, 1)
        } else {
          // Add completion
          completions.push(date)
        }

        // Calculate current streak
        const sortedCompletions = completions.sort((a, b) => new Date(b) - new Date(a))
        let currentStreak = 0
        const today = new Date()
        
        for (let i = 0; i < sortedCompletions.length; i++) {
          const completionDate = new Date(sortedCompletions[i])
          const daysDiff = Math.floor((today - completionDate) / (1000 * 60 * 60 * 24))
          
          if (daysDiff === i) {
            currentStreak++
          } else {
            break
          }
        }

        const bestStreak = Math.max(habit.bestStreak, currentStreak)

        return {
          ...habit,
          completions,
          streak: currentStreak,
          bestStreak
        }
      }
      return habit
    }))
  }

  return (
    <div className="app">
      <header className="app-header">
        <h1>🎯 Habit Tracker</h1>
        <nav className="tab-nav">
          <button 
            className={activeTab === 'habits' ? 'tab active' : 'tab'}
            onClick={() => setActiveTab('habits')}
          >
            My Habits
          </button>
          <button 
            className={activeTab === 'dashboard' ? 'tab active' : 'tab'}
            onClick={() => setActiveTab('dashboard')}
          >
            Dashboard
          </button>
        </nav>
      </header>

      <main className="app-main">
        {activeTab === 'habits' && (
          <>
            <HabitForm onAddHabit={addHabit} />
            <HabitList 
              habits={habits} 
              onDeleteHabit={deleteHabit}
              onToggleCompletion={toggleHabitCompletion}
            />
          </>
        )}
        
        {activeTab === 'dashboard' && (
          <Dashboard habits={habits} />
        )}
      </main>
    </div>
  )
}

export default App
