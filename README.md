# cordova-text-zoom-limiter

Plugin Cordova para **limitar el zoom de texto** (accesibilidad) en la WebView, en Android e iOS.
Expone una API JavaScript en `window.TextZoomLimiter`.

## Instalación

```bash
cordova plugin add ./cordova-text-zoom-limiter
```

Estructura esperada:

```
cordova-text-zoom-limiter/
├── plugin.xml
├── README.md
├── www/
│   └── TextZoomLimiter.js
└── src/
    ├── android/
    │   └── TextZoomPlugin.java
    └── ios/
        └── TextZoomPlugin.swift
```

## API JavaScript

Disponible después de `deviceready` en `window.TextZoomLimiter`.

### `getTextZoom()`

Obtiene el zoom de texto actual del sistema.

```typescript
const zoom = await window.TextZoomLimiter.getTextZoom();
console.log(zoom);
// { textZoom: 150, percentage: "150%", platform: "android" }
```

### `setTextZoomMax(maxZoom: number)`

Limita el zoom de texto a un máximo permitido.

```typescript
const result = await window.TextZoomLimiter.setTextZoomMax(120);
console.log(result);
// { appliedZoom: 120, previousZoom: 150, maxZoom: 120, platform: "ios" }
```

### `setTextZoom(zoom: number)`

Establece el zoom de texto a un valor específico (rango típico 50–200).

```typescript
const res = await window.TextZoomLimiter.setTextZoom(100);
console.log(res);
// { textZoom: 100, message: "Zoom establecido a: 100%", platform: "android" }
```

### `getPlatformInfo()`

Devuelve información básica de la plataforma.

```typescript
const info = await window.TextZoomLimiter.getPlatformInfo();
console.log(info);
// { platform: "ios", version: "17.2", model: "iPhone" }
```

## Uso típico (Ionic/Angular)

```typescript
import { Component, OnInit } from '@angular/core';
declare let window: any;

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html'
})
export class AppComponent implements OnInit {
  
  ngOnInit() {
    document.addEventListener('deviceready', () => this.initTextZoom());
  }

  private async initTextZoom() {
    try {
      // Limitar zoom de texto del sistema a 120 %
      const result = await window.TextZoomLimiter.setTextZoomMax(120);
      console.log('✅ Zoom limitado:', result);
    } catch (e) {
      console.error('❌ Error:', e);
    }
  }
}
```

## Servicio reutilizable (Angular)

```typescript
import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

declare let window: any;

@Injectable({ providedIn: 'root' })
export class TextZoomService {
  
  private zoomSubject = new BehaviorSubject<number>(100);
  public zoom$ = this.zoomSubject.asObservable();

  async getTextZoom() {
    return window.TextZoomLimiter?.getTextZoom() || { textZoom: 100 };
  }

  async setTextZoomMax(maxZoom: number) {
    const result = await window.TextZoomLimiter?.setTextZoomMax(maxZoom);
    if (result) {
      this.zoomSubject.next(result.appliedZoom);
    }
    return result;
  }

  async setTextZoom(zoom: number) {
    const result = await window.TextZoomLimiter?.setTextZoom(zoom);
    if (result) {
      this.zoomSubject.next(zoom);
    }
    return result;
  }

  async getPlatformInfo() {
    return window.TextZoomLimiter?.getPlatformInfo();
  }
}
```

## Plataformas soportadas

- ✅ Android (API 21+, con cordova-plugin-ionic-webview)
- ✅ iOS (11.0+, WKWebView)
- ✅ Cordova 10.0+
- ✅ Ionic Framework 5.0+

## Nota importante (Accesibilidad)

Este plugin **limita el zoom de texto preferido del usuario**.

⚠️ **Úsalo solo si:**
- El diseño se rompe con zoom altos (>150%)
- Hayas probado que un diseño responsivo no funciona
- Documentes claramente el comportamiento para tus usuarios

## Licencia

MIT
