// src/app/app.ts
import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { CommonModule } from '@angular/common';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule],
  templateUrl: './app.html',
  styleUrls: ['./app.css']
})
export class AppComponent {
  files: { number: string; status: string }[] = [];
  apiUrl = 'http://localhost:3000'; // keep this if backend runs locally

  private pollTimer: any;

  constructor(private http: HttpClient) {}

  ngOnInit() {
    this.loadFiles();
    this.pollTimer = setInterval(() => this.loadFiles(), 6000);
  }

  ngOnDestroy() {
    if (this.pollTimer) clearInterval(this.pollTimer);
  }

loadFiles() {
  this.http.get<{ id: string; status: string }[]>(`${this.apiUrl}/status`)
    .subscribe({
      next: (data) => {
        this.files = data
          .map(f => ({ number: f.id, status: f.status })) // convert id → number
          .sort((a, b) => Number(a.number) - Number(b.number));
      },
      error: (err) => {
        console.error('Failed to fetch files', err);
        this.files = [];
      }
    });
}


  // helper for template
  statusClass(status: string) {
    if (!status) return '';
    const s = status.toLowerCase();
    if (s === 'default') return 'status-default';
    if (s === 'charge') return 'status-charge';
    if (s === 'decharge') return 'status-decharge';
    return '';
  }

  statusLabel(status: string) {
    if (!status) return 'unknown';
    const s = status.toLowerCase();
    if (s === 'default') return 'Default';
    if (s === 'charge') return 'Loaded';
    if (s === 'decharge') return 'Unloaded';
    return status;
  }
}
