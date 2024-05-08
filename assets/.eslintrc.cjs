module.exports = {
  env: {
    browser: true,
    es2021: true
  },
  extends: ['standard-with-typescript', 'prettier'],
  overrides: [
    {
      env: {
        node: true
      },
      files: ['.eslintrc.{js,cjs}', '*.js', '*.jsx', '*.ts', '*.tsx'],
      parserOptions: {
        sourceType: 'script',
		project: ['./tsconfig.json']
      }
    }
  ],
  parserOptions: {
    ecmaVersion: 'latest',
    sourceType: 'module'
  },
  ignorePatterns: ['**/vendor/*.js'],
  rules: {
    '@typescript-eslint/naming-convention': [
      "error",
      {
        'selector': 'variable',
        'format': ['snake_case']
      }
    ],
    'prefer-arrow-callback': 'error',
    'arrow-body-style': ['error', 'as-needed'],
    'arrow-parens': ['error', 'as-needed']
  }
}
