defmodule Duplicar do

#punto4
  def eliminar_duplicados(piezas) do
    piezas_invertidas = invertir_lista(piezas, [])
    sin_duplicados = eliminar_duplicados_aux(piezas_invertidas, MapSet.new(), [])

    invertir_lista(sin_duplicados, [])
  end

 defp invertir_lista([], acumulador), do: acumulador
  defp invertir_lista([elem | resto], acumulador) do
    invertir_lista(resto, [elem | acumulador])
  end

  defp eliminar_duplicados_aux([], _vistos, acumulador) do
    acumulador
  end

  defp eliminar_duplicados_aux([pieza | resto], vistos, acumulador) do
    if MapSet.member?(vistos, pieza.codigo) do
       eliminar_duplicados_aux(resto, vistos, acumulador)
    else
      nuevos_vistos = MapSet.put(vistos, pieza.codigo)
      eliminar_duplicados_aux(resto, nuevos_vistos, [pieza | acumulador])
    end
  end
end
