import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { getRepresentative } from "../api/client";
import type { Representative } from "../api/client";

export function RepresentativePage() {
  const { id } = useParams();
  const [representative, setRepresentative] = useState<Representative | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string>();

  useEffect(() => {
    if (!id) return;
    const numId = Number(id);
    if (Number.isNaN(numId)) {
      setError("ID inválido");
      setLoading(false);
      return;
    }

    (async () => {
      try {
        const data = await getRepresentative(numId);
        setRepresentative(data);
      } catch (err: any) {
        setError(err.message || "Error al cargar representante");
      } finally {
        setLoading(false);
      }
    })();
  }, [id]);

  if (loading) return <p>Cargando...</p>;
  if (error) return <p style={{ color: "red" }}>{error}</p>;
  if (!representative) return <p>No se encontró el representante.</p>;

  return (
    <main style={{ maxWidth: "800px", margin: "0 auto", padding: "16px" }}>
      <h1>{representative.full_name}</h1>
      <p><strong>RUT:</strong> {representative.rut}</p>

      <section style={{ marginTop: "24px" }}>
        <h2>Empresas asociadas</h2>
        {representative.companies && representative.companies.length > 0 ? (
          <ul>
            {representative.companies.map((c) => (
              <li key={c.id}>
                <Link to={`/companies/${c.id}`}>
                  {c.name}
                </Link>{" "}
                — {c.rut}
                {c.role && <span> ({c.role})</span>}
              </li>
            ))}
          </ul>
        ) : (
          <p>No hay empresas asociadas.</p>
        )}
      </section>

      <p style={{ marginTop: "24px" }}>
        <Link to="/">← Volver a la búsqueda</Link>
      </p>
    </main>
  );
}