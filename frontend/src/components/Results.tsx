import { Link } from "react-router-dom";
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
    <div style={{ display: "grid", gap: "24px", marginTop: "16px" }}>
      {companies.length > 0 && (
        <section>
          <h2>Empresas ({companies.length})</h2>
          <div style={{ display: "grid", gap: "12px" }}>
            {companies.map((c) => {
              const legalRep = c.representatives?.find((r) =>
                r.role?.toLowerCase().includes("representante")
              );
              return (
                <div
                  key={c.id}
                  style={{
                    border: "1px solid #ddd",
                    padding: "12px",
                    borderRadius: "8px",
                  }}
                >
                  <h3>
                    <Link to={`/companies/${c.id}`}>{c.name}</Link>
                  </h3>
                  <p>
                    <strong>RUT:</strong> {c.rut}
                  </p>

                  {legalRep && (
                    <p>
                      <strong>Representante legal:</strong>{" "}
                      <Link to={`/representatives/${legalRep.id}`}>
                        {legalRep.full_name}
                      </Link>{" "}
                      — {legalRep.rut}
                    </p>
                  )}

                  {c.comuna_social && (
                    <p>
                      <strong>Domicilio social:</strong> {c.comuna_social}
                      {c.region_social ? `, ${c.region_social}` : ""}
                    </p>
                  )}

                  {c.representatives && c.representatives.length > 0 && (
                    <div>
                      <strong>Otros representantes:</strong>
                      <ul>
                        {c.representatives.map((r) => (
                          <li key={r.id}>
                            <Link to={`/representatives/${r.id}`}>
                              {r.full_name}
                            </Link>{" "}
                            — {r.rut}
                            {r.role && <span> ({r.role})</span>}
                          </li>
                        ))}
                      </ul>
                    </div>
                  )}
                </div>
              );
            })}
          </div>
        </section>
      )}

      {representatives.length > 0 && (
        <section>
          <h2>Representantes ({representatives.length})</h2>
          <div style={{ display: "grid", gap: "12px" }}>
            {representatives.map((r) => (
              <div
                key={r.id}
                style={{
                  border: "1px solid #ddd",
                  padding: "12px",
                  borderRadius: "8px",
                }}
              >
                <h3>
                  <Link to={`/representatives/${r.id}`}>{r.full_name}</Link>
                </h3>
                <p>
                  <strong>RUT:</strong> {r.rut}
                </p>
                {r.companies && r.companies.length > 0 && (
                  <div>
                    <strong>Empresas asociadas:</strong>
                    <ul>
                      {r.companies.map((c) => (
                        <li key={c.id}>
                          <Link to={`/companies/${c.id}`}>{c.name}</Link>{" "}
                          — {c.rut}
                          {c.role && <span> ({c.role})</span>}
                        </li>
                      ))}
                    </ul>
                  </div>
                )}
              </div>
            ))}
          </div>
        </section>
      )}
    </div>
  );
}
