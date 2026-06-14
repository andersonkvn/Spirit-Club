-- ================================================================
-- SPIRIT CLUB — SQL Setup (jalankan di Supabase SQL Editor)
-- ================================================================

-- 1. TABEL DAFTAR MEMBER
CREATE TABLE IF NOT EXISTS daftar_member (
  id           SERIAL PRIMARY KEY,
  id_member    TEXT UNIQUE NOT NULL,
  nama_member  TEXT NOT NULL,
  email        TEXT UNIQUE NOT NULL,
  handicap     INTEGER DEFAULT 15,
  base_score   INTEGER DEFAULT 200,
  created_at   TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TABEL SKOR MINGGUAN
CREATE TABLE IF NOT EXISTS skor_mingguan (
  id                SERIAL PRIMARY KEY,
  tanggal           DATE NOT NULL,
  email             TEXT NOT NULL,
  id_member         TEXT NOT NULL,
  nama_member       TEXT NOT NULL,
  game1             INTEGER NOT NULL CHECK (game1 BETWEEN 0 AND 300),
  game2             INTEGER NOT NULL CHECK (game2 BETWEEN 0 AND 300),
  game3             INTEGER NOT NULL CHECK (game3 BETWEEN 0 AND 300),
  total_skor        INTEGER NOT NULL,
  average           DECIMAL(5,1) NOT NULL,
  best_game         INTEGER NOT NULL,
  handicap_per_game INTEGER DEFAULT 0,
  total_handicap    INTEGER DEFAULT 0,
  keterangan        TEXT,
  created_at        TIMESTAMPTZ DEFAULT NOW()
);

-- 3. ROW LEVEL SECURITY
ALTER TABLE daftar_member  ENABLE ROW LEVEL SECURITY;
ALTER TABLE skor_mingguan  ENABLE ROW LEVEL SECURITY;

-- Member bisa lihat profil sendiri
CREATE POLICY "member_read_own_profile" ON daftar_member
  FOR SELECT USING (auth.jwt() ->> 'email' = email);

-- Member bisa input skor sendiri
CREATE POLICY "member_insert_own_score" ON skor_mingguan
  FOR INSERT WITH CHECK (auth.jwt() ->> 'email' = email);

-- Member bisa lihat skor sendiri
CREATE POLICY "member_read_own_score" ON skor_mingguan
  FOR SELECT USING (auth.jwt() ->> 'email' = email);

-- Semua member bisa lihat skor orang lain (untuk leaderboard)
-- GANTI 'domain-klub.com' atau pakai list email jika perlu lebih private
CREATE POLICY "all_read_for_leaderboard" ON skor_mingguan
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "all_read_members_for_lb" ON daftar_member
  FOR SELECT USING (auth.role() = 'authenticated');

-- Admin bisa insert member baru (ganti dengan email admin asli)
CREATE POLICY "admin_insert_member" ON daftar_member
  FOR INSERT WITH CHECK (auth.jwt() ->> 'email' = 'EMAIL_ADMIN@gmail.com');

-- 4. DATA MEMBER CONTOH (ganti email dengan Gmail asli)
INSERT INTO daftar_member (id_member, nama_member, email, handicap, base_score) VALUES
  ('M001', 'Budi Santoso',   'budi@gmail.com',   16, 200),
  ('M002', 'Rina Wulandari', 'rina@gmail.com',   12, 200),
  ('M003', 'Agus Priyono',   'agus@gmail.com',   18, 200),
  ('M004', 'Dewi Lestari',   'dewi@gmail.com',   10, 200),
  ('M005', 'Hendra Gunawan', 'hendra@gmail.com', 15, 200)
ON CONFLICT (email) DO NOTHING;

-- 5. DATA SKOR CONTOH (opsional, untuk testing)
INSERT INTO skor_mingguan (tanggal,email,id_member,nama_member,game1,game2,game3,total_skor,average,best_game,handicap_per_game,total_handicap) VALUES
  ('2025-03-03','dewi@gmail.com',  'M004','Dewi Lestari',  200,213,198,611,203.7,213,0,611),
  ('2025-03-03','rina@gmail.com',  'M002','Rina Wulandari',178,182,175,535,178.3,182,7,556),
  ('2025-03-03','hendra@gmail.com','M005','Hendra Gunawan',165,170,168,503,167.7,170,11,536),
  ('2025-03-03','budi@gmail.com',  'M001','Budi Santoso',  155,162,170,487,162.3,170,14,529),
  ('2025-03-03','agus@gmail.com',  'M003','Agus Priyono',  145,150,148,443,147.7,150,21,506),
  ('2025-02-24','dewi@gmail.com',  'M004','Dewi Lestari',  195,205,200,600,200.0,205,0,600),
  ('2025-02-24','rina@gmail.com',  'M002','Rina Wulandari',172,178,180,530,176.7,180,7,551),
  ('2025-02-24','hendra@gmail.com','M005','Hendra Gunawan',160,165,170,495,165.0,170,11,528),
  ('2025-02-24','budi@gmail.com',  'M001','Budi Santoso',  148,155,160,463,154.3,160,14,505),
  ('2025-02-24','agus@gmail.com',  'M003','Agus Priyono',  140,145,142,427,142.3,145,21,490),
  ('2025-02-17','dewi@gmail.com',  'M004','Dewi Lestari',  210,208,195,613,204.3,210,0,613),
  ('2025-02-17','rina@gmail.com',  'M002','Rina Wulandari',175,180,176,531,177.0,180,7,552),
  ('2025-02-17','budi@gmail.com',  'M001','Budi Santoso',  150,158,155,463,154.3,158,14,505),
  ('2025-02-17','hendra@gmail.com','M005','Hendra Gunawan',158,162,165,485,161.7,165,11,518),
  ('2025-02-10','budi@gmail.com',  'M001','Budi Santoso',  160,155,162,477,159.0,162,14,519),
  ('2025-02-10','agus@gmail.com',  'M003','Agus Priyono',  138,142,145,425,141.7,145,21,488)
ON CONFLICT DO NOTHING;
