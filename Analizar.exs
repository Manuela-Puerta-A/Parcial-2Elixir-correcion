defmodule Analizar do
#punto3
  def analizar_rango(movimientos, fecha_ini, fecha_fin) do
    with true <- validar_fecha(fecha_ini),
         true <- validar_fecha(fecha_fin),
         true <- fecha_ini <= fecha_fin do


      resultado = procesar_rango(movimientos, fecha_ini, fecha_fin, MapSet.new(), 0)
      {:ok, resultado}
    else
      _ -> {:error, "Fechas inválidas o rango incorrecto"}
    end
  end


  defp procesar_rango([], _ini, _fin, dias_set, max_cantidad) do
    {MapSet.size(dias_set), max_cantidad}
  end

  defp procesar_rango([mov | resto], ini, fin, dias_set, max_cantidad) do
    if mov.fecha >= ini and mov.fecha <= fin do

      nuevo_dias_set = MapSet.put(dias_set, mov.fecha)
      nuevo_max = max(max_cantidad, mov.cantidad)
      procesar_rango(resto, ini, fin, nuevo_dias_set, nuevo_max)
    else

      procesar_rango(resto, ini, fin, dias_set, max_cantidad)
    end
  end

  defp validar_fecha(fecha) do
    case String.split(fecha, "-") do
      [anio, mes, dia] ->
        with {a, ""} <- Integer.parse(anio),
             {m, ""} <- Integer.parse(mes),
             {d, ""} <- Integer.parse(dia),
             true <- a > 0 and m >= 1 and m <= 12 and d >= 1 and d <= 31 do
          true
        else
          _ -> false
        end
      _ -> false
    end
  end
end
