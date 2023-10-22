using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

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

            migrationBuilder.InsertData(
                table: "Drzavas",
                columns: new[] { "DrzavaID", "Naziv" },
                values: new object[,]
                {
                    { 1, "Bosna i Hercegovina" },
                    { 2, "Hrvatska" },
                    { 3, "Srbija" }
                });

            migrationBuilder.InsertData(
                table: "Grads",
                columns: new[] { "GradID", "Naziv" },
                values: new object[,]
                {
                    { 1, "Sarajevo" },
                    { 2, "Zagreb" },
                    { 3, "Beograd" }
                });

            migrationBuilder.InsertData(
                table: "Ulogas",
                columns: new[] { "UlogaID", "Naziv", "Opis" },
                values: new object[,]
                {
                    { 1, "Administrator", "Administrator" },
                    { 2, "Uposlenik", "Uposlenik" }
                });

            migrationBuilder.InsertData(
                table: "Uplatas",
                columns: new[] { "UplataID", "BrojTransakcije", "DatumTransakcije", "Iznos" },
                values: new object[,]
                {
                    { 1, "pi_3MSSv3ANnFXjgSPx2LOrScMr", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7975), 146.0 },
                    { 2, "pi_3MSSwtANnFXjgSPx1GLV7ZWR", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7979), 196.0 },
                    { 3, "pi_3MSSxZANnFXjgSPx1h6sZONh", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7981), 122.0 },
                    { 4, "pi_3MSSykANnFXjgSPx0j7dwFvL", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7983), 132.0 },
                    { 5, "pi_3MSSzFANnFXjgSPx1K5yB3MP", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7986), 148.0 },
                    { 6, "pi_3MSSzgANnFXjgSPx30vUfLBv", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7988), 136.0 },
                    { 7, "pi_3MST02ANnFXjgSPx28dm4Ke1", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7990), 66.0 }
                });

            migrationBuilder.InsertData(
                table: "VrstaProizvodas",
                columns: new[] { "VrstaProizvodaID", "Naziv", "Opis" },
                values: new object[,]
                {
                    { 1, "Torta", "Torta" },
                    { 2, "Kolac", "Kolac" },
                    { 3, "Kolacic", "Kolacic" },
                    { 4, "Pite", "Pita" },
                    { 5, "Cokoladni napitak", "Cokoladni napitak" },
                    { 6, "Quiche", "Quiche" },
                    { 7, "Vocna salata", "Vocna salata" },
                    { 8, "Dzem", "Dzem" },
                    { 9, "Marmelada", "Marmelada" }
                });

            migrationBuilder.InsertData(
                table: "Korisniks",
                columns: new[] { "KorisnikID", "DatumRodjenja", "DrzavaID", "Email", "GradID", "Ime", "KorisnickoIme", "LozinkaHash", "LozinkaSalt", "Prezime", "Telefon" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7511), 1, "admin@gmail.com", 1, "Admin", "admin", "/xMQieQ3uGPTlzPRymTnCYF0zdQ=", "eOiUUE75RAT+/j1aeQn6UA==", "Admin", "000000000" },
                    { 2, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7728), 2, "uposlenik@gmail.com", 2, "Uposlenik", "uposlenik", "tpQoJ0uudPu598n2hmAXSEsvHE0=", "wJuCSeVxKQ64ZtfzD4cJKw==", "Uposlenik", "000000001" },
                    { 3, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7758), 3, "user@gmail.com", 3, "User", "user", "hvu3VtzhFOXpmjqJ9FSg4YQnlPc=", "ZncUk3RS/Dycf6Kr0SdfPA==", "User", "000000002" },
                    { 4, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7786), 2, "uposlenik2@gmail.com", 2, "Uposlenik2", "uposlenik2", "Dm68FcB8jetODygzVTdOgDdk4bo=", "bLnw/JfO9PG1zVN3t0vR0g==", "Uposlenik2", "000000003" },
                    { 5, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7814), 3, "user2@gmail.com", 3, "User2", "user2", "683kWhAf9evsE1kVhjf30Zv1KPk=", "6fXgu+VyXY0Xutw+f5SXsQ==", "User2", "000000002" }
                });

            migrationBuilder.InsertData(
                table: "KorisnikUlogas",
                columns: new[] { "KorisnikUlogaID", "DatumIzmjene", "KorisnikID", "UlogaID" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7895), 1, 1 },
                    { 2, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7899), 1, 2 },
                    { 3, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7902), 2, 2 },
                    { 4, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7904), 4, 2 }
                });

            migrationBuilder.InsertData(
                table: "Narudzbas",
                columns: new[] { "NarudzbaID", "BrojNarudzbe", "DatumNarudzbe", "IsCanceled", "IsShipped", "KorisnikID", "UplataID" },
                values: new object[,]
                {
                    { 1, "0d5b4fd7-dbe9-48c8-b5df-5e5e69c9fd27", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(8037), false, true, 3, 1 },
                    { 2, "e22f02ea-49a3-4078-801c-7c109ce1f9df", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(8043), false, true, 3, 2 },
                    { 3, "b34e2629-ef8c-4ee5-861a-a26538afa4d5", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(8049), false, false, 3, 3 },
                    { 4, "77189430-0a73-4c39-9396-6af33a815758", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(8054), false, false, 5, 4 },
                    { 5, "88f70a46-638e-47d6-91ba-df1aa48a91c0", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(8064), false, true, 5, 5 },
                    { 6, "5475c2ee-88b7-4348-8b74-f7d61e2508c9", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(8069), false, true, 5, 6 },
                    { 7, "442bce47-bd13-47af-88a3-a53cb0f7c524", new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(8074), false, false, 3, 7 }
                });

            migrationBuilder.InsertData(
                table: "Recenzijas",
                columns: new[] { "RecenzijaID", "DatumKreiranja", "KorisnikID", "Ocjena", "SadrzajRecenzije" },
                values: new object[,]
                {
                    { 1, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7948), 3, 4, "Torta je odlicna" },
                    { 2, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7953), 3, 5, "Vrhunski sladoled" },
                    { 3, new DateTime(2023, 10, 22, 16, 42, 37, 851, DateTimeKind.Local).AddTicks(7957), 3, 3, "Kolac je mogao biti bolji" }
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
