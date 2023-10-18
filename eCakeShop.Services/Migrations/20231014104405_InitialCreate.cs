using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace eCakeShop.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Drzavas",
                columns: table => new
                {
                    DrzavaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Drzavas", x => x.DrzavaID);
                });

            migrationBuilder.CreateTable(
                name: "Grads",
                columns: table => new
                {
                    GradID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Grads", x => x.GradID);
                });

            migrationBuilder.CreateTable(
                name: "Ulogas",
                columns: table => new
                {
                    UlogaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Ulogas", x => x.UlogaID);
                });

            migrationBuilder.CreateTable(
                name: "Uplatas",
                columns: table => new
                {
                    UplataID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Iznos = table.Column<double>(type: "float", nullable: false),
                    DatumTransakcije = table.Column<DateTime>(type: "datetime2", nullable: false),
                    BrojTransakcije = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Uplatas", x => x.UplataID);
                });

            migrationBuilder.CreateTable(
                name: "VrstaProizvodas",
                columns: table => new
                {
                    VrstaProizvodaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_VrstaProizvodas", x => x.VrstaProizvodaID);
                });

            migrationBuilder.CreateTable(
                name: "Korisniks",
                columns: table => new
                {
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DatumRodjenja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    Email = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Telefon = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    GradID = table.Column<int>(type: "int", nullable: false),
                    DrzavaID = table.Column<int>(type: "int", nullable: false),
                    KorisnickoIme = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(max)", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Korisniks", x => x.KorisnikID);
                    table.ForeignKey(
                        name: "FK_Korisniks_Drzavas_DrzavaID",
                        column: x => x.DrzavaID,
                        principalTable: "Drzavas",
                        principalColumn: "DrzavaID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Korisniks_Grads_GradID",
                        column: x => x.GradID,
                        principalTable: "Grads",
                        principalColumn: "GradID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Proizvods",
                columns: table => new
                {
                    ProizvodID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Sifra = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Cijena = table.Column<decimal>(type: "decimal(18,2)", nullable: false),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    VrstaProizvodaID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Proizvods", x => x.ProizvodID);
                    table.ForeignKey(
                        name: "FK_Proizvods_VrstaProizvodas_VrstaProizvodaID",
                        column: x => x.VrstaProizvodaID,
                        principalTable: "VrstaProizvodas",
                        principalColumn: "VrstaProizvodaID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "KorisnikUlogas",
                columns: table => new
                {
                    KorisnikUlogaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    UlogaID = table.Column<int>(type: "int", nullable: false),
                    DatumIzmjene = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_KorisnikUlogas", x => x.KorisnikUlogaID);
                    table.ForeignKey(
                        name: "FK_KorisnikUlogas_Korisniks_KorisnikID",
                        column: x => x.KorisnikID,
                        principalTable: "Korisniks",
                        principalColumn: "KorisnikID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_KorisnikUlogas_Ulogas_UlogaID",
                        column: x => x.UlogaID,
                        principalTable: "Ulogas",
                        principalColumn: "UlogaID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Narudzbas",
                columns: table => new
                {
                    NarudzbaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    UplataID = table.Column<int>(type: "int", nullable: false),
                    BrojNarudzbe = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: false),
                    DatumNarudzbe = table.Column<DateTime>(type: "datetime2", nullable: false),
                    IsCanceled = table.Column<bool>(type: "bit", nullable: false),
                    IsShipped = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Narudzbas", x => x.NarudzbaID);
                    table.ForeignKey(
                        name: "FK_Narudzbas_Korisniks_KorisnikID",
                        column: x => x.KorisnikID,
                        principalTable: "Korisniks",
                        principalColumn: "KorisnikID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Narudzbas_Uplatas_UplataID",
                        column: x => x.UplataID,
                        principalTable: "Uplatas",
                        principalColumn: "UplataID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Novosts",
                columns: table => new
                {
                    NovostID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naslov = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Sadrzaj = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Thumbnail = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Novosts", x => x.NovostID);
                    table.ForeignKey(
                        name: "FK_Novosts_Korisniks_KorisnikID",
                        column: x => x.KorisnikID,
                        principalTable: "Korisniks",
                        principalColumn: "KorisnikID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Recenzijas",
                columns: table => new
                {
                    RecenzijaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SadrzajRecenzije = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Ocjena = table.Column<int>(type: "int", nullable: false),
                    DatumKreiranja = table.Column<DateTime>(type: "datetime2", nullable: false),
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Recenzijas", x => x.RecenzijaID);
                    table.ForeignKey(
                        name: "FK_Recenzijas_Korisniks_KorisnikID",
                        column: x => x.KorisnikID,
                        principalTable: "Korisniks",
                        principalColumn: "KorisnikID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Slikas",
                columns: table => new
                {
                    SlikaID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    SlikaByte = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Opis = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    KorisnikID = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Slikas", x => x.SlikaID);
                    table.ForeignKey(
                        name: "FK_Slikas_Korisniks_KorisnikID",
                        column: x => x.KorisnikID,
                        principalTable: "Korisniks",
                        principalColumn: "KorisnikID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "NarudzbaProizvodis",
                columns: table => new
                {
                    NarudzbaProizvodiID = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ProizvodID = table.Column<int>(type: "int", nullable: false),
                    NarudzbaID = table.Column<int>(type: "int", nullable: false),
                    Kolicina = table.Column<int>(type: "int", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_NarudzbaProizvodis", x => x.NarudzbaProizvodiID);
                    table.ForeignKey(
                        name: "FK_NarudzbaProizvodis_Narudzbas_NarudzbaID",
                        column: x => x.NarudzbaID,
                        principalTable: "Narudzbas",
                        principalColumn: "NarudzbaID",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_NarudzbaProizvodis_Proizvods_ProizvodID",
                        column: x => x.ProizvodID,
                        principalTable: "Proizvods",
                        principalColumn: "ProizvodID",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Korisniks_DrzavaID",
                table: "Korisniks",
                column: "DrzavaID");

            migrationBuilder.CreateIndex(
                name: "IX_Korisniks_GradID",
                table: "Korisniks",
                column: "GradID");

            migrationBuilder.CreateIndex(
                name: "IX_KorisnikUlogas_KorisnikID",
                table: "KorisnikUlogas",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_KorisnikUlogas_UlogaID",
                table: "KorisnikUlogas",
                column: "UlogaID");

            migrationBuilder.CreateIndex(
                name: "IX_NarudzbaProizvodis_NarudzbaID",
                table: "NarudzbaProizvodis",
                column: "NarudzbaID");

            migrationBuilder.CreateIndex(
                name: "IX_NarudzbaProizvodis_ProizvodID",
                table: "NarudzbaProizvodis",
                column: "ProizvodID");

            migrationBuilder.CreateIndex(
                name: "IX_Narudzbas_KorisnikID",
                table: "Narudzbas",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Narudzbas_UplataID",
                table: "Narudzbas",
                column: "UplataID");

            migrationBuilder.CreateIndex(
                name: "IX_Novosts_KorisnikID",
                table: "Novosts",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Proizvods_VrstaProizvodaID",
                table: "Proizvods",
                column: "VrstaProizvodaID");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzijas_KorisnikID",
                table: "Recenzijas",
                column: "KorisnikID");

            migrationBuilder.CreateIndex(
                name: "IX_Slikas_KorisnikID",
                table: "Slikas",
                column: "KorisnikID");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "KorisnikUlogas");

            migrationBuilder.DropTable(
                name: "NarudzbaProizvodis");

            migrationBuilder.DropTable(
                name: "Novosts");

            migrationBuilder.DropTable(
                name: "Recenzijas");

            migrationBuilder.DropTable(
                name: "Slikas");

            migrationBuilder.DropTable(
                name: "Ulogas");

            migrationBuilder.DropTable(
                name: "Narudzbas");

            migrationBuilder.DropTable(
                name: "Proizvods");

            migrationBuilder.DropTable(
                name: "Korisniks");

            migrationBuilder.DropTable(
                name: "Uplatas");

            migrationBuilder.DropTable(
                name: "VrstaProizvodas");

            migrationBuilder.DropTable(
                name: "Drzavas");

            migrationBuilder.DropTable(
                name: "Grads");
        }
    }
}
