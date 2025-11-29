import './App.css'
import { Routes, Route } from 'react-router-dom'
import { SearchPage } from './pages/SearchPage'
import { CompanyPage } from './pages/CompanyPage'
import { RepresentativePage } from './pages/RepresentativePage'

function App() {
  return (
    <div className="App">
      <Routes>
        <Route path="/" element={<SearchPage />} />
        <Route path="/companies/:id" element={<CompanyPage />} />
        <Route path="/representatives/:id" element={<RepresentativePage />} />
      </Routes>
    </div>
  )
}

export default App
