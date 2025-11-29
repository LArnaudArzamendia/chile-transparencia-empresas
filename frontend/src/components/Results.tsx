import type { Company, Representative } from "../api/client";

interface Props {
  companies: Company[];
  representatives: Representative[];
  loading: boolean;
  error?: string;
}

export function Results({ companies, representatives, loading, error }: Props) {
  if (loading) return <p>Cargando...</p>;
  if (error) return <p style={{ color: "red" }}>{error}</p>;
  if (!companies.length && !representatives.length)
    return <p>Sin resultados.</p>;

  return (
    <div style={{ display: "grid", gap: "16px", marginTop: "16px" }}>
      {companies.length > 0 && (
        <section>
          <h2>Empresas ({companies.length})</h2>
          <ul>
            {companies.map((c) => (
              <li key={c.id}>
                <strong>{c.name}</strong> — {c.rut}
              </li>
            ))}
          </ul>
        </section>
      )}

      {representatives.length > 0 && (
        <section>
          <h2>Representantes ({representatives.length})</h2>
          <ul>
            {representatives.map((r) => (
              <li key={r.id}>
                <strong>{r.full_name}</strong> — {r.rut}
                {r.companies?.length > 0 && (
                  <div style={{ marginLeft: "16px" }}>
                    <em>Empresas asociadas:</em>
                    <ul>
                      {r.companies.map((c) => (
                        <li key={c.id}>
                          {c.name} ({c.rut})
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
              </li>
            ))}
          </ul>
        </section>
      )}
    </div>
  );
}
