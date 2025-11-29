const API_BASE_URL = "http://localhost:3000/api/v1";

export interface Company {
  id: number;
  rut: string;
  name: string;
}

export interface Representative {
  id: number;
  rut: string;
  full_name: string;
  companies: Company[];
}

export interface SearchResponse {
  query: string;
  companies: Company[];
  representatives: Representative[];
}

export async function search(query: string): Promise<SearchResponse> {
  const url = new URL(`${API_BASE_URL}/search`);
  url.searchParams.set("q", query);

  const res = await fetch(url.toString());
  if (!res.ok) {
    throw new Error("Error fetching search results");
  }
  return res.json();
}
