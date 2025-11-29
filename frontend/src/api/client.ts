const API_BASE_URL = "http://localhost:3000/api/v1";

export interface CompanyRepresentativeSummary {
  id: number;
  rut: string;
  full_name: string;
  role?: string | null;
}

export interface RepresentativeCompanySummary {
  id: number;
  rut: string;
  name: string;
  role?: string | null;
}

export interface Company {
  id: number;
  rut: string;
  name: string;
  year?: number | null;
  comuna_social?: string | null;
  region_social?: string | null;
  representatives?: CompanyRepresentativeSummary[];
}

export interface Representative {
  id: number;
  rut: string;
  full_name: string;
  companies: RepresentativeCompanySummary[];
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

// Detalle de empresa.
export async function getCompany(id: number): Promise<Company & { representatives: CompanyRepresentativeSummary[] }> {
  const res = await fetch(`${API_BASE_URL}/companies/${id}`);
  if (!res.ok) {
    throw new Error("Error fetching company");
  }
  return res.json();
}

// Detalle de representante.
export async function getRepresentative(
  id: number
): Promise<Representative> {
  const res = await fetch(`${API_BASE_URL}/representatives/${id}`);
  if (!res.ok) {
    throw new Error("Error fetching representative");
  }
  return res.json();
}