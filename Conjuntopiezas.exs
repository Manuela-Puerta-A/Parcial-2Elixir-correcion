defmodule Conjuntopiezas do
  #punto1b
    case File.read(nombre_archivo) do
      {:ok, contenido} ->
        lineas = String.split(contenido, "\n", trim: true)
        procesar_lineas(lineas, [])

      {:error, razon} ->
        {:error, "No se pudo leer el archivo: #{razon}"}
    end
  end

  defp procesar_lineas([], acumulador) do
    {:ok, Enum.reverse(acumulador)}
  end

  defp procesar_lineas([linea | resto], acumulador) do
    case parsear_linea(linea) do
      {:ok, pieza} ->
         procesar_lineas(resto, [pieza | acumulador])

      {:error, razon} ->
        {:error, razon}
    end
  end
  def contar_stock_bajo([], _umbral, contador) do
    contador
  end

  def contar_stock_bajo([pieza | resto], umbral, contador) do
    nuevo_contador = if pieza.stock < umbral, do: contador + 1, else: contador
    contar_stock_bajo(resto, umbral, nuevo_contador)
  end

  def contar_stock_bajo(piezas, umbral) when is_integer(umbral) do
    contar_stock_bajo(piezas, umbral, 0)
  end
