import { useEffect, useState } from "react";
import { useParams, Link } from "react-router-dom";
import { getCompany } from "../api/client";
import type { Company, CompanyRepresentativeSummary } from "../api/client";

type CompanyWithReps = Company & { representatives?: CompanyRepresentativeSummary[] };

export function CompanyPage() {
  const { id } = useParams();
  const [company, setCompany] = useState<CompanyWithReps | null>(null);
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
        const data = await getCompany(numId);
        setCompany(data);
      } catch (err: any) {
        setError(err.message || "Error al cargar empresa");
      } finally {
        setLoading(false);
      }
    })();
  }, [id]);

  if (loading) return <p>Cargando...</p>;
  if (error) return <p style={{ color: "red" }}>{error}</p>;
  if (!company) return <p>No se encontró la empresa.</p>;

  return (
    <main style={{ maxWidth: "800px", margin: "0 auto", padding: "16px" }}>
      <h1>{company.name}</h1>
      <p><strong>RUT:</strong> {company.rut}</p>
      {company.year && <p><strong>Año constitución:</strong> {company.year}</p>}
      {company.comuna_social && (
        <p>
          <strong>Domicilio social:</strong> {company.comuna_social}
          {company.region_social ? `, ${company.region_social}` : ""}
        </p>
      )}

      <section style={{ marginTop: "24px" }}>
        <h2>Representantes</h2>
        {company.representatives && company.representatives.length > 0 ? (
          <ul>
            {company.representatives.map((rep) => (
              <li key={rep.id}>
                <Link to={`/representatives/${rep.id}`}>
                  {rep.full_name}
                </Link>{" "}
                — {rep.rut}
                {rep.role && <span> ({rep.role})</span>}
              </li>
            ))}
          </ul>
        ) : (
          <p>No hay representantes registrados.</p>
        )}
      </section>

      <p style={{ marginTop: "24px" }}>
        <Link to="/">← Volver a la búsqueda</Link>
      </p>
    </main>
  );
}