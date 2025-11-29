import { useState } from "react";
import { SearchBar } from "../components/SearchBar";
import { Results } from "../components/Results";
import { search } from "../api/client"; 
import type { Company, Representative } from "../api/client";

export function SearchPage() {
  const [companies, setCompanies] = useState<Company[]>([]);
  const [representatives, setRepresentatives] = useState<Representative[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string>();

  const handleSearch = async (query: string) => {
    try {
      setLoading(true);
      setError(undefined);
      const res = await search(query);
      setCompanies(res.companies || []);
      setRepresentatives(res.representatives || []);
    } catch (err: any) {
      setError(err.message || "Error desconocido");
    } finally {
      setLoading(false);
    }
  };

  return (
    <main style={{ maxWidth: "800px", margin: "0 auto", padding: "16px" }}>
      <h1>Buscador de Empresas en Chile</h1>
      <SearchBar onSearch={handleSearch} />
      <Results
        companies={companies}
        representatives={representatives}
        loading={loading}
        error={error}
      />
    </main>
  );
}
