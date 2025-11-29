import { useState } from "react";
import type { FormEvent } from "react";

interface Props {
  onSearch: (query: string) => void;
}

export function SearchBar({ onSearch }: Props) {
  const [value, setValue] = useState("");

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (value.trim()) {
      onSearch(value.trim());
    }
  };

  return (
    <form onSubmit={handleSubmit} style={{ display: "flex", gap: "8px" }}>
      <input
        type="text"
        placeholder="Buscar por RUT o nombre de empresa/representante..."
        value={value}
        onChange={(e) => setValue(e.target.value)}
        style={{ flex: 1, padding: "8px" }}
      />
      <button type="submit">Buscar</button>
    </form>
  );
}
