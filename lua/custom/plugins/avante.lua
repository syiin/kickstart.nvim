return {
  'yetone/avante.nvim',
  version = false,
  event = 'VeryLazy',
  build = 'make BUILD_FROM_SOURCE=true',
  opts = {
    provider = 'ollama',
    ollama = {
      -- model = 'qwen3:30b',
      model = 'qwen2.5-coder:32b',
      disable_tools = false,
    },
    behaviour = {
      enable_cursor_planning_mode = true,
    },
  },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'hrsh7th/nvim-cmp',
  },
  rag_service = {
    enabled = true, -- Enables the RAG service
    host_mount = os.getenv 'HOME', -- Host mount path for the rag service
    provider = 'ollama', -- The provider to use for RAG service (e.g. openai or ollama)
    llm_model = 'qwen3:30b', -- The LLM model to use for RAG service
    embed_model = 'bge-m3:latest', -- The embedding model to use for RAG service
    endpoint = 'http://localhost:11434', -- The API endpoint for RAG service
  },
}
