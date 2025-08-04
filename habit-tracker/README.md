# 🎯 Habit Tracker App

A beautiful and intuitive habit tracking application built with React and Vite. Track your daily habits, monitor your progress, and build lasting routines with an elegant and user-friendly interface.

## ✨ Features

### 🏠 Core Functionality
- **Add Custom Habits**: Create personalized habits with names, descriptions, and categories
- **Track Completions**: Mark habits as complete with a simple click
- **Visual Calendar**: Interactive 7-day calendar view for each habit
- **Streak Tracking**: Monitor current and best streaks for motivation
- **Categories**: Organize habits into meaningful categories with color coding

### 📊 Analytics & Insights
- **Progress Dashboard**: Comprehensive statistics and progress visualization
- **Weekly Charts**: Visual representation of your weekly habit completion
- **Completion Rates**: Calculate and display habit completion percentages
- **Category Breakdown**: Track progress across different habit categories
- **Best Performer**: Highlight your most consistent habit

### 🎨 User Experience
- **Modern UI**: Clean, responsive design with beautiful gradients and animations
- **Intuitive Navigation**: Easy-to-use tab-based navigation between habits and dashboard
- **Local Storage**: Automatic data persistence without external dependencies
- **Mobile Responsive**: Optimized for both desktop and mobile devices
- **Smooth Animations**: Delightful interactions and transitions

## 🚀 Getting Started

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd habit-tracker
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start the development server**
   ```bash
   npm run dev
   ```

4. **Open in browser**
   - Navigate to `http://localhost:5173` (or the port shown in terminal)

### Build for Production
```bash
npm run build
npm run preview
```

## 📱 How to Use

### Adding a New Habit
1. Click the **"+ Add New Habit"** button
2. Fill in the habit details:
   - **Name**: What you want to track (e.g., "Drink 8 glasses of water")
   - **Description**: Optional additional details
   - **Category**: Choose from predefined categories
   - **Frequency**: Daily, Weekly, or Monthly
3. Click **"Create Habit"** to save

### Tracking Progress
- **Mark Complete**: Click the "Mark Complete" button or use the calendar view
- **View Streaks**: Monitor your current and best streaks in the habit card
- **Calendar Interaction**: Click on any day in the 7-day calendar to toggle completion

### Viewing Analytics
1. Switch to the **"Dashboard"** tab
2. View your statistics:
   - Total habits and completions
   - Active streaks count
   - Today's completion progress
   - Weekly progress chart
   - Category breakdown with progress bars

## 🎨 Categories

The app includes 7 predefined categories, each with unique colors and icons:

- 🏃 **Health & Fitness** - Exercise, nutrition, wellness habits
- 📚 **Learning & Growth** - Reading, studying, skill development
- ⚡ **Productivity** - Work, organization, efficiency habits
- 🧘 **Mindfulness** - Meditation, reflection, mental health
- 👥 **Social** - Relationships, communication, community
- 🎨 **Creative** - Art, writing, musical, creative pursuits
- 📝 **Other** - Any habits that don't fit other categories

## 🛠️ Technical Details

### Built With
- **React 19** - Modern React with hooks
- **Vite** - Fast build tool and development server
- **CSS3** - Custom styling with CSS Grid and Flexbox
- **Local Storage API** - Client-side data persistence

### Project Structure
```
habit-tracker/
├── src/
│   ├── components/
│   │   ├── HabitForm.jsx      # Habit creation form
│   │   ├── HabitList.jsx      # List of habits organized by category
│   │   ├── HabitCard.jsx      # Individual habit display and interaction
│   │   └── Dashboard.jsx      # Analytics and statistics
│   ├── App.jsx                # Main application component
│   ├── App.css               # Comprehensive styling
│   └── main.jsx              # Application entry point
├── public/                   # Static assets
└── package.json             # Dependencies and scripts
```

### Key Features Implementation

#### State Management
- Uses React's `useState` and `useEffect` hooks
- Centralized state in the main App component
- Props drilling for component communication

#### Data Persistence
- Automatic localStorage integration
- JSON serialization/deserialization
- Data loads on app initialization

#### Streak Calculation
- Dynamic streak calculation based on consecutive completions
- Handles both current and best streak tracking
- Date-based completion tracking

#### Responsive Design
- Mobile-first approach
- CSS Grid and Flexbox for layouts
- Responsive breakpoints for different screen sizes

## 🔧 Customization

### Adding New Categories
1. Update the `categories` array in relevant components
2. Add corresponding colors and emojis
3. Ensure consistency across `HabitForm.jsx` and `HabitList.jsx`

### Styling Modifications
- Main styles are in `src/App.css`
- CSS custom properties for easy color theming
- Modular CSS classes for component-specific styling

### Feature Extensions
- **Data Export**: Add JSON export functionality
- **Habit Templates**: Pre-defined habit suggestions
- **Notifications**: Browser notifications for habit reminders
- **Goals**: Set and track habit goals
- **Social Features**: Share progress with friends

## 📊 Data Structure

### Habit Object
```javascript
{
  id: Number,              // Unique identifier
  name: String,            // Habit name
  description: String,     // Optional description
  category: String,        // Category key
  frequency: String,       // 'daily', 'weekly', 'monthly'
  completions: Array,      // Array of date strings
  createdAt: String,       // ISO date string
  streak: Number,          // Current streak
  bestStreak: Number       // Best streak achieved
}
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Guidelines
1. Follow the existing code style
2. Write meaningful commit messages
3. Test your changes thoroughly
4. Update documentation as needed

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- Icons from emoji characters for cross-platform compatibility
- Color palette inspired by modern design trends
- Animation principles from Google Material Design

---

**Happy Habit Building! 🎯**
