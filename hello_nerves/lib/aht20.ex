defmodule AHT20 do
  @i2c_bus "i2c-1"
  @i2c_addr 0x38
  @initialization_command <<0xBE, 0x08, 0x00>>
  @trigger_measurement_command <<0xAC, 0x33, 0x00>>
  @two_pow_20 2 ** 20

  def read do
    {:ok, ref} = Circuits.I2C.open(@i2c_bus)

    Circuits.I2C.write(ref, @i2c_addr, @initialization_command)
    Process.sleep(10)

    Circuits.I2C.write(ref, @i2c_addr, @trigger_measurement_command)
    Process.sleep(80)

    result =
      Circuits.I2C.read(ref, @i2c_addr, 7)
      |> convert()

    Circuits.I2C.close(ref)

    result
  end

  def convert({:ok, <<_state, raw_humidity::20, raw_temperature::20, _crc>>}) do
    humidity = (raw_humidity / @two_pow_20 * 100.0) |> Float.round(1)

    temperature =
      (raw_temperature / @two_pow_20 * 200.0 - 50.0)
      |> Float.round(1)

    {:ok, %{humidity: humidity, temperature: temperature}}
  end

  def convert({:error, error}), do: {:error, error}
  def convert(_), do: {:error, "An error occurred"}
end
