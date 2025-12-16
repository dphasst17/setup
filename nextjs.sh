# Scaffold Next.js frontend (TypeScript)
echo "Scaffolding Next.js frontend (frontend)..."
mkdir -p frontend
cd frontend
echo "Install dependencies..."
npm init -y >/dev/null 2>&1

echo "Installing Next.js, React, TypeScript and Webpack..."
npm install next@^14.2.0 react@^18.3.0 react-dom@^18.3.0

# 3. Dev dependencies
npm install --save-dev \
  typescript @types/react @types/react-dom @types/node \
  webpack@5 webpack-cli webpack-dev-server \
  fork-ts-checker-webpack-plugin \
  ts-loader \
  css-loader style-loader \
  postcss-loader postcss postcss-preset-env \
  tailwindcss autoprefixer \
  eslint eslint-config-next \
  concurrently


# 4. Setup project structure and config files
echo "Setting up project structure..."
cat > tsconfig.json <<'EOF'
{
  "compilerOptions": {
    "target": "ES2017",
    "lib": [
      "dom",
      "dom.iterable",
      "esnext"
    ],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "react-jsx",
    "incremental": true,
    "plugins": [
      {
        "name": "next"
      }
    ],
    "paths": {
      "@/*": [
        "./src/*"
      ]
    }
  },
  "include": [
    "next-env.d.ts",
    "**/*.ts",
    "**/*.tsx",
    ".next/types/**/*.ts",
    ".next/dev/types/**/*.ts",
    "**/*.mts",
    ".next\\dev/types/**/*.ts",
    ".next\\dev/types/**/*.ts"
  ],
  "exclude": [
    "node_modules"
  ]
}

EOF

cat > next.config.mjs <<'EOF'
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,

  // Example: custom webpack config
  webpack(config) {
    config.module.rules.push({
      test: /\.md$/,
      use: 'raw-loader',
    });
    return config;
  },

  // Example: redirects
  async redirects() {
    return [
      {
        source: '/old-route',
        destination: '/new-route',
        permanent: true,
      },
    ];
  },
};

export default nextConfig;

EOF

cat > eslint.config.mjs <<'EOF'
import { defineConfig, globalIgnores } from "eslint/config";
import nextVitals from "eslint-config-next/core-web-vitals";
import nextTs from "eslint-config-next/typescript";

const eslintConfig = defineConfig([
  ...nextVitals,
  ...nextTs,
  // Override default ignores of eslint-config-next.
  globalIgnores([
    // Default ignores of eslint-config-next:
    ".next/**",
    "out/**",
    "build/**",
    "next-env.d.ts",
  ]),
]);

export default eslintConfig;
EOF

cat > postcss.config.mjs <<'EOF'
const config = {
  plugins: {
    "@tailwindcss/postcss": {},
  },
};

export default config;
EOF

cat > tailwind.config.cjs <<'EOF'
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
};
EOF

cat > .gitignore <<'EOF'
# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.

# dependencies
/node_modules
/.pnp
.pnp.*
.yarn/*
!.yarn/patches
!.yarn/plugins
!.yarn/releases
!.yarn/versions

# testing
/coverage

# next.js
/.next/
/out/

# production
/build

# misc
.DS_Store
*.pem

# debug
npm-debug.log*
yarn-debug.log*
yarn-error.log*
.pnpm-debug.log*

# env files (can opt-in for committing if needed)
.env*

# vercel
.vercel

# typescript
*.tsbuildinfo
next-env.d.ts
EOF
mkdir -p src/app src/components src/pages src/styles src/public src/libs \
    src/types src/hooks src/features src/helpers src/configs src/constants

touch src/app/page.tsx src/app/layout.tsx src/styles/globals.css
#write basic layout and page
cat > src/app/layout.tsx <<'EOF'
import type { Metadata } from "next";
import { Geist, Geist_Mono } from "next/font/google";
import "./globals.css";

// ========== METADATA OPTIMIZATION SEO ==========
export const metadata: Metadata = {
  // main title
  title: {
    default: "Website Name | Tagline short",
    template: "%s | Website Name" // Template for other pages
  },
  
  // description
  description: "This is a brief and engaging description of the website for search engines.",
  
  // Canonical URL - avoid duplicate content
  metadataBase: new URL("https://yourdomain.com"),
  
  // Open Graph for Social Media
  openGraph: {
    title: "Website Name",
    description: "Description for Facebook, Twitter",
    url: "https://yourdomain.com",
    siteName: "Website Name",
    images: [
      {
        url: "/og-image.jpg", // 1200x630px
        width: 1200,
        height: 630,
        alt: "Website Name - OG Image",
      },
    ],
    locale: "vi_VN",
    type: "website",
  },
  
  // Twitter Card
  /* twitter: {
    card: "summary_large_image",
    title: "Website Name",
    description: "Description for Twitter",
    images: ["/twitter-image.jpg"], // 1200x675px
  }, */
  
  // Robots - search engine
  robots: {
    index: true,
    follow: true,
    googleBot: {
      index: true,
      follow: true,
      "max-video-preview": -1,
      "max-image-preview": "large",
      "max-snippet": -1,
    },
  },
  
  // Verification codes
  verification: {
    google: "your-google-verification-code",
    yandex: "your-yandex-code",
  },
  
  // Icons & Favicons
  icons: {
    icon: "/favicon.ico",
    shortcut: "/favicon-16x16.png",
    apple: "/apple-touch-icon.png",
  },
  
  // Alternates cho i18n/multilingual
  alternates: {
    canonical: "/",
    languages: {
      "en-US": "/en",
      //"vi-VN": "/vi",
      //"fr-FR": "/fr",
      //es-ES": "/es",
      //de-DE": "/de",
      //ja-JP": "/ja",
      //zh-CN": "/zh",
      //ru-RU": "/ru",
      //other languages...
    },
  },
};

// ========== FONTS ==========
const geistSans = Geist({
  variable: "--font-geist-sans",
  subsets: ["latin"],
  display: "swap",
});

const geistMono = Geist_Mono({
  variable: "--font-geist-mono",
  subsets: ["latin"],
  display: "swap",
});

// ========== ROOT LAYOUT ==========
export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html 
      lang="en" 
      suppressHydrationWarning // Avoid  warning when metadata dynamic
    >
      <head>
        {/* Preload critical resources */}
        <link rel="preload" href="/fonts/geist.woff2" as="font" type="font/woff2" crossOrigin="anonymous" />
        
        {/* DNS Prefetch cho external domains */}
        <link rel="dns-prefetch" href="//fonts.googleapis.com" />
        <link rel="dns-prefetch" href="//images.unsplash.com" />
        
        {/* Structured Data - Schema.org */}
        <script
          type="application/ld+json"
          dangerouslySetInnerHTML={{
            __html: JSON.stringify({
              "@context": "https://schema.org",
              "@type": "Organization",
              name: "Your Organization Name",
              url: "https://yourdomain.com",
              logo: "https://yourdomain.com/logo.png",
              sameAs: [
                "https://facebook.com/yourpage",
                "https://instagram.com/yourpage",
              ],
            }),
          }}
        />
      </head>
      
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
EOF
#write basic page
cat > src/app/page.tsx <<'EOF'
import Image from "next/image";

export default function Home() {
  return (
    <div className="flex min-h-screen items-center justify-center bg-zinc-50 font-sans dark:bg-black">
      <main className="flex min-h-screen w-full max-w-3xl flex-col items-center justify-between py-32 px-16 bg-white dark:bg-black sm:items-start">
        <Image
          className="dark:invert"
          src="/next.svg"
          alt="Next.js logo"
          width={100}
          height={20}
          priority
        />
        <div className="flex flex-col items-center gap-6 text-center sm:items-start sm:text-left">
          <h1 className="max-w-xs text-3xl font-semibold leading-10 tracking-tight text-black dark:text-zinc-50">
            To get started, edit the page.tsx file.
          </h1>
          <p className="max-w-md text-lg leading-8 text-zinc-600 dark:text-zinc-400">
            Looking for a starting point or more instructions? Head over to{" "}
            <a
              href="https://vercel.com/templates?framework=next.js&utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
              className="font-medium text-zinc-950 dark:text-zinc-50"
            >
              Templates
            </a>{" "}
            or the{" "}
            <a
              href="https://nextjs.org/learn?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
              className="font-medium text-zinc-950 dark:text-zinc-50"
            >
              Learning
            </a>{" "}
            center.
          </p>
        </div>
        <div className="flex flex-col gap-4 text-base font-medium sm:flex-row">
          <a
            className="flex h-12 w-full items-center justify-center gap-2 rounded-full bg-foreground px-5 text-background transition-colors hover:bg-[#383838] dark:hover:bg-[#ccc] md:w-[158px]"
            href="https://vercel.com/new?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
            target="_blank"
            rel="noopener noreferrer"
          >
            <Image
              className="dark:invert"
              src="/vercel.svg"
              alt="Vercel logomark"
              width={16}
              height={16}
            />
            Deploy Now
          </a>
          <a
            className="flex h-12 w-full items-center justify-center rounded-full border border-solid border-black/[.08] px-5 transition-colors hover:border-transparent hover:bg-black/[.04] dark:border-white/[.145] dark:hover:bg-[#1a1a1a] md:w-[158px]"
            href="https://nextjs.org/docs?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
            target="_blank"
            rel="noopener noreferrer"
          >
            Documentation
          </a>
        </div>
      </main>
    </div>
  );
}
EOF
