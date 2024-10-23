# Gasolina Flotilla App

**Gasolina Flotilla App** es una aplicación en Flutter diseñada para gestionar y calcular el consumo de gasolina de una flotilla de vehículos técnicos, que se dedican a reparar fibra óptica en zonas afectadas. La app permite a los usuarios capturar una foto del odómetro junto con la ubicación GPS actual, calculando así el consumo de combustible con base en los datos obtenidos. El valor de consumo predeterminado es de **10 km/l**, pero puede ser modificado.

## Características

- **Captura de fotos del odómetro**: Permite a los técnicos tomar fotos del odómetro de los vehículos.
- **Ubicación GPS**: Guarda la ubicación (latitud y longitud) en el momento en que se captura la foto.
- **Cálculo de consumo**: Basado en el kilometraje, la aplicación calculará el consumo de gasolina.
- **OCR (Reconocimiento de texto)**: Extrae el valor del odómetro de las fotos utilizando OCR.
- **Arquitectura MVVM**: Implementada para una clara separación de responsabilidades y fácil escalabilidad.

## Requisitos

### 1. Flutter
Es necesario tener instalado Flutter. Puedes seguir las instrucciones de instalación en: [Flutter - Get Started](https://flutter.dev/docs/get-started/install).
