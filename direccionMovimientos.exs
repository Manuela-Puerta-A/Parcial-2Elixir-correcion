defmodule direccionMovimientos do

  def leer_movimientos(nombre_archivo) do
    case File.read(nombre_archivo) do
      {:ok, contenido} ->
        lineas = String.split(contenido, "\n", trim: true)
        procesar_movimientos(lineas, [])

      {:error, razon} ->
        {:error, "No se pudo leer el archivo: #{razon}"}
    end
  end
  defp procesar_movimientos([], acumulador) do
    {:ok, Enum.reverse(acumulador)}
  end

  defp procesar_movimientos([linea | resto], acumulador) do
    case parsear_movimiento(linea) do
      {:ok, movimiento} ->
        procesar_movimientos(resto, [movimiento | acumulador])

      {:error, razon} ->
        {:error, razon}
    end
  end

  defp parsear_movimiento(linea) do
    campos = String.split(linea, ",", trim: true)

    case campos do
      [codigo, tipo, cantidad_str, fecha] ->
        with true <- tipo in ["ENTRADA", "SALIDA"],
             {cantidad, ""} <- Integer.parse(cantidad_str),
             true <- cantidad > 0,
             true <- validar_fecha(fecha) do
          movimiento = %Movimiento{
            codigo: codigo,
            tipo: tipo,
            cantidad: cantidad,

          }
          {:ok, movimiento}
        else
          _ -> {:error, "Datos inválidos en movimiento: #{linea}"}
        end

      _ ->
        {:error, "Formato incorrecto en movimiento: #{linea}"}
    end
  end


  def aplicar_movimientos(piezas, movimientos) do
    aplicar_movimientos_recursivo(piezas, movimientos)
  end

  defp aplicar_movimientos_recursivo(piezas, []) do
    piezas
  end

  defp aplicar_movimientos_recursivo(piezas, [movimiento | resto_movimientos]) do
    piezas_actualizadas = actualizar_pieza(piezas, movimiento, [])
    aplicar_movimientos_recursivo(piezas_actualizadas, resto_movimientos)
  end
  defp actualizar_pieza([], _movimiento, acumulador) do
    Enum.reverse(acumulador)
  end

  defp actualizar_pieza([pieza | resto], movimiento, acumulador) do
    if pieza.codigo == movimiento.codigo do
      nuevo_stock = case movimiento.tipo do
        "ENTRADA" -> pieza.stock + movimiento.cantidad
        "SALIDA" -> max(0, pieza.stock - movimiento.cantidad)
      end

      pieza_actualizada = %Pieza{pieza | stock: nuevo_stock}
      actualizar_pieza(resto, movimiento, [pieza_actualizada | acumulador])
    else
      actualizar_pieza(resto, movimiento, [pieza | acumulador])
    end
  end


  def guardar_inventario(piezas, nombre_archivo) do
    contenido = generar_csv(piezas, "")

    case File.write(nombre_archivo, contenido) do
      :ok -> {:ok, "Inventario guardado exitosamente"}
      {:error, razon} -> {:error, "No se pudo guardar: #{razon}"}
    end
  end

  defp generar_csv([], contenido), do: contenido

  defp generar_csv([pieza | resto], contenido) do
    linea = "#{pieza.codigo},#{pieza.nombre},#{pieza.valor},#{pieza.unidad},#{pieza.stock}\n"
    generar_csv(resto, contenido <> linea)
  end
end
