using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using SportWear.Web.Models;

namespace SportWear.Web.Services;

public class CotizacionPdfService
{
    public byte[] Generar(Cotizacion cotizacion)
    {
        return Document.Create(documento =>
        {
            documento.Page(pagina =>
            {
                pagina.Size(PageSizes.A4);
                pagina.Margin(35);

                pagina.DefaultTextStyle(
                    estilo => estilo
                        .FontSize(10)
                        .FontFamily(Fonts.Arial));

                pagina.Header()
                    .Element(contenedor =>
                        CrearEncabezado(contenedor, cotizacion));

                pagina.Content()
                    .PaddingVertical(20)
                    .Element(contenedor =>
                        CrearContenido(contenedor, cotizacion));

                pagina.Footer()
                    .AlignCenter()
                    .Text(texto =>
                    {
                        texto.Span("SportWear · Cotización comercial · ");
                        texto.CurrentPageNumber();
                        texto.Span(" de ");
                        texto.TotalPages();
                    });
            });
        }).GeneratePdf();
    }

    private static void CrearEncabezado(
        IContainer contenedor,
        Cotizacion cotizacion)
    {
        contenedor
            .Background("#2E1065")
            .Padding(20)
            .Row(fila =>
            {
                fila.RelativeItem()
                    .Column(columna =>
                    {
                        columna.Item()
                            .Text("SPORTWEAR")
                            .FontSize(23)
                            .Bold()
                            .FontColor("#B7F34A");

                        columna.Item()
                            .PaddingTop(4)
                            .Text("Confección y ropa deportiva")
                            .FontSize(10)
                            .FontColor(Colors.White);
                    });

                fila.ConstantItem(190)
                    .AlignRight()
                    .Column(columna =>
                    {
                        columna.Item()
                            .AlignRight()
                            .Text("COTIZACIÓN")
                            .FontSize(18)
                            .Bold()
                            .FontColor(Colors.White);

                        columna.Item()
                            .AlignRight()
                            .PaddingTop(4)
                            .Text(cotizacion.Codigo)
                            .FontSize(11)
                            .FontColor("#B7F34A");

                        columna.Item()
                            .AlignRight()
                            .PaddingTop(3)
                            .Text(
                                $"Emisión: {cotizacion.FechaEmision:dd/MM/yyyy}")
                            .FontSize(9)
                            .FontColor(Colors.White);
                    });
            });
    }

    private static void CrearContenido(
        IContainer contenedor,
        Cotizacion cotizacion)
    {
        contenedor.Column(columna =>
        {
            columna.Spacing(18);

            columna.Item()
                .Element(c =>
                    CrearDatosCliente(c, cotizacion));

            columna.Item()
                .Element(c =>
                    CrearDetalleProducto(c, cotizacion));

            columna.Item()
                .Element(c =>
                    CrearResumenEconomico(c, cotizacion));

            if (!string.IsNullOrWhiteSpace(cotizacion.Observaciones))
            {
                columna.Item()
                    .Border(1)
                    .BorderColor("#DDD6FE")
                    .Background("#FAF8FF")
                    .Padding(12)
                    .Column(observacion =>
                    {
                        observacion.Item()
                            .Text("OBSERVACIONES")
                            .Bold()
                            .FontColor("#6D28D9");

                        observacion.Item()
                            .PaddingTop(5)
                            .Text(cotizacion.Observaciones);
                    });
            }

            columna.Item()
                .PaddingTop(10)
                .Text(
                    "La presente cotización tiene carácter informativo y estará vigente hasta la fecha indicada.")
                .FontSize(8)
                .FontColor(Colors.Grey.Darken1);
        });
    }

    private static void CrearDatosCliente(
        IContainer contenedor,
        Cotizacion cotizacion)
    {
        contenedor.Column(columna =>
        {
            columna.Item()
                .Text("DATOS DEL CLIENTE")
                .FontSize(12)
                .Bold()
                .FontColor("#6D28D9");

            columna.Item()
                .PaddingTop(8)
                .Border(1)
                .BorderColor("#E8E3F2")
                .Padding(12)
                .Table(tabla =>
                {
                    tabla.ColumnsDefinition(columnas =>
                    {
                        columnas.RelativeColumn();
                        columnas.RelativeColumn();
                    });

                    AgregarDato(
                        tabla,
                        "Cliente",
                        cotizacion.NombreCliente);

                    AgregarDato(
                        tabla,
                        "Documento",
                        cotizacion.Documento ?? "No registrado");

                    AgregarDato(
                        tabla,
                        "Teléfono",
                        cotizacion.Telefono ?? "No registrado");

                    AgregarDato(
                        tabla,
                        "Correo",
                        cotizacion.Correo ?? "No registrado");
                });
        });
    }

    private static void CrearDetalleProducto(
        IContainer contenedor,
        Cotizacion cotizacion)
    {
        decimal adicionalUnitario = ObtenerCostoAdicionalEstampado(cotizacion.TipoEstampado);
        decimal precioBaseUnitario = Math.Max(cotizacion.PrecioUnitario - adicionalUnitario, 0);
        decimal importeBase = precioBaseUnitario * cotizacion.Cantidad;
        decimal importeAdicional = adicionalUnitario * cotizacion.Cantidad;

        contenedor.Column(columna =>
        {
            columna.Item()
                .Text("DETALLE DE LA CONFECCIÓN")
                .FontSize(12)
                .Bold()
                .FontColor("#6D28D9");

            columna.Item()
                .PaddingTop(8)
                .Table(tabla =>
                {
                    tabla.ColumnsDefinition(columnas =>
                    {
                        columnas.RelativeColumn(3);
                        columnas.RelativeColumn();
                        columnas.RelativeColumn();
                        columnas.RelativeColumn();
                    });

                    tabla.Header(encabezado =>
                    {
                        EncabezadoTabla(encabezado, "Concepto");
                        EncabezadoTabla(encabezado, "Cantidad");
                        EncabezadoTabla(encabezado, "Precio unit.");
                        EncabezadoTabla(encabezado, "Importe");
                    });

                    CeldaTabla(tabla, $"{cotizacion.NombreProducto} - precio base");
                    CeldaTabla(tabla, cotizacion.Cantidad.ToString());
                    CeldaTabla(tabla, $"S/ {precioBaseUnitario:N2}");
                    CeldaTabla(tabla, $"S/ {importeBase:N2}");

                    if (adicionalUnitario > 0)
                    {
                        CeldaTabla(tabla, $"Adicional por {Valor(cotizacion.TipoEstampado)}");
                        CeldaTabla(tabla, cotizacion.Cantidad.ToString());
                        CeldaTabla(tabla, $"S/ {adicionalUnitario:N2}");
                        CeldaTabla(tabla, $"S/ {importeAdicional:N2}");
                    }

                    tabla.Cell()
                        .ColumnSpan(4)
                        .BorderBottom(1)
                        .BorderColor("#E8E3F2")
                        .Padding(10)
                        .Text(texto =>
                        {
                            texto.Span("Personalización: ").Bold();
                            texto.Span(
                                $"Talla {Valor(cotizacion.Talla)}, " +
                                $"color {Valor(cotizacion.Color)}, " +
                                $"material {Valor(cotizacion.Material)}, " +
                                $"estampado {Valor(cotizacion.TipoEstampado)}.");
                        });

                    tabla.Cell()
                        .ColumnSpan(4)
                        .PaddingTop(7)
                        .Text("La regla actual aplica recargo económico por tipo de estampado. Talla, color y material se muestran como especificaciones y no agregan recargo adicional.")
                        .FontSize(8)
                        .FontColor(Colors.Grey.Darken1);
                });
        });
    }

    private static void CrearResumenEconomico(
        IContainer contenedor,
        Cotizacion cotizacion)
    {
        decimal adicionalUnitario = ObtenerCostoAdicionalEstampado(cotizacion.TipoEstampado);
        decimal precioBaseUnitario = Math.Max(cotizacion.PrecioUnitario - adicionalUnitario, 0);
        decimal importeBase = precioBaseUnitario * cotizacion.Cantidad;
        decimal importeAdicional = adicionalUnitario * cotizacion.Cantidad;
        decimal importeBruto = cotizacion.PrecioUnitario * cotizacion.Cantidad;
        decimal descuentoMonto = Math.Max(importeBruto - cotizacion.Subtotal, 0);

        contenedor.Row(fila =>
        {
            fila.RelativeItem();

            fila.ConstantItem(300)
                .Border(1)
                .BorderColor("#DDD6FE")
                .Background("#FAF8FF")
                .Padding(15)
                .Column(columna =>
                {
                    columna.Spacing(8);

                    FilaMonto(
                        columna,
                        "Importe base",
                        $"S/ {importeBase:N2}");

                    FilaMonto(
                        columna,
                        $"Adicional {Valor(cotizacion.TipoEstampado)}",
                        $"S/ {importeAdicional:N2}");

                    FilaMonto(
                        columna,
                        "Importe antes de descuento",
                        $"S/ {importeBruto:N2}");

                    FilaMonto(
                        columna,
                        $"Descuento por volumen ({cotizacion.DescuentoPorcentaje:N2} %)",
                        descuentoMonto > 0 ? $"- S/ {descuentoMonto:N2}" : "S/ 0.00");

                    FilaMonto(
                        columna,
                        "Subtotal después del descuento",
                        $"S/ {cotizacion.Subtotal:N2}");

                    FilaMonto(
                        columna,
                        "IGV (18 %)",
                        $"S/ {cotizacion.Igv:N2}");

                    columna.Item()
                        .PaddingTop(8)
                        .BorderTop(2)
                        .BorderColor("#A78BFA")
                        .PaddingTop(10)
                        .Row(total =>
                        {
                            total.RelativeItem()
                                .Text("TOTAL")
                                .FontSize(13)
                                .Bold()
                                .FontColor("#2E1065");

                            total.RelativeItem()
                                .AlignRight()
                                .Text($"S/ {cotizacion.Total:N2}")
                                .FontSize(19)
                                .Bold()
                                .FontColor("#6D28D9");
                        });

                    columna.Item()
                        .PaddingTop(6)
                        .Text(
                            cotizacion.FechaVencimiento.HasValue
                                ? $"Válida hasta: {cotizacion.FechaVencimiento:dd/MM/yyyy}"
                                : "Sin fecha de vencimiento")
                        .FontSize(8)
                        .FontColor(Colors.Grey.Darken1);
                });
        });
    }

    private static decimal ObtenerCostoAdicionalEstampado(string? tipoEstampado)
    {
        return tipoEstampado?.Trim().ToUpperInvariant() switch
        {
            "SUBLIMACIÓN" => 8.00m,
            "SERIGRAFÍA" => 5.00m,
            "BORDADO" => 10.00m,
            _ => 0.00m
        };
    }

    private static void AgregarDato(
        TableDescriptor tabla,
        string etiqueta,
        string valor)
    {
        tabla.Cell()
            .PaddingVertical(5)
            .Text(texto =>
            {
                texto.Span($"{etiqueta}: ").Bold();
                texto.Span(valor);
            });
    }

    private static void EncabezadoTabla(
        TableCellDescriptor encabezado,
        string texto)
    {
        encabezado.Cell()
            .Background("#6D28D9")
            .Padding(8)
            .Text(texto)
            .Bold()
            .FontColor(Colors.White);
    }

    private static void CeldaTabla(
        TableDescriptor tabla,
        string texto)
    {
        tabla.Cell()
            .BorderBottom(1)
            .BorderColor("#E8E3F2")
            .Padding(9)
            .Text(texto);
    }

    private static void FilaMonto(
        ColumnDescriptor columna,
        string concepto,
        string monto)
    {
        columna.Item()
            .Row(fila =>
            {
                fila.RelativeItem()
                    .Text(concepto)
                    .FontColor(Colors.Grey.Darken2);

                fila.RelativeItem()
                    .AlignRight()
                    .Text(monto)
                    .Bold();
            });
    }

    private static string Valor(string? valor)
    {
        return string.IsNullOrWhiteSpace(valor)
            ? "no especificado"
            : valor;
    }
}