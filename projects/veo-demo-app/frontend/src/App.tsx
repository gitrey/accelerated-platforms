import React, { useState, useEffect, useRef } from 'react';
import { 
  Video, 
  Image as ImageIcon, 
  Settings, 
  Play, 
  Download, 
  Loader2, 
  AlertCircle,
  CheckCircle2,
  ChevronRight,
  Upload,
  Layers
} from 'lucide-react';
import { 
  triggerVeo2TextToVideo, 
  triggerVeo2ImageToVideo,
  triggerVeo3TextToVideo, 
  triggerVeo3ImageToVideo,
  uploadImage,
  type Veo3ImageToVideoRequest 
} from './api';

type Model = 'Veo 2.0' | 'Veo 3.1';
type Mode = 'Text-to-Video' | 'Image-to-Video';

interface ProgressMessage {
  type: 'progress' | 'status' | 'result' | 'error';
  message: string;
  data?: any;
}

function App() {
  const [model, setModel] = useState<Model>('Veo 3.1');
  const [mode, setMode] = useState<Mode>('Text-to-Video');
  const [prompt, setPrompt] = useState('');
  const [negativePrompt, setNegativePrompt] = useState('');
  const [aspectRatio, setAspectRatio] = useState('16:9');
  const [duration, setDuration] = useState(6);
  const [isGenerating, setIsGenerating] = useState(false);
  const [progress, setProgress] = useState<ProgressMessage[]>([]);
  const [resultVideo, setResultVideo] = useState<string | null>(null);
  const [selectedImage, setSelectedImage] = useState<File | null>(null);
  const [imagePreview, setImagePreview] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  
  const scrollRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (scrollRef.current) {
      scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
    }
  }, [progress]);

  const handleImageChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.files && e.target.files[0]) {
      const file = e.target.files[0];
      setSelectedImage(file);
      setImagePreview(URL.createObjectURL(file));
    }
  };

  const handleGenerate = async () => {
    setIsGenerating(true);
    setProgress([]);
    setResultVideo(null);
    setError(null);

    try {
      let imageGcsUri = '';
      if (mode === 'Image-to-Video' && selectedImage) {
        setProgress(prev => [...prev, { type: 'status', message: 'Uploading image...' }]);
        const uploadResp = await uploadImage(selectedImage);
        imageGcsUri = uploadResp.gcs_uri;
        setProgress(prev => [...prev, { type: 'status', message: 'Image uploaded successfully.' }]);
      }

      const request: Veo3ImageToVideoRequest = {
        prompt,
        negative_prompt: negativePrompt,
        aspect_ratio: aspectRatio,
        duration_seconds: duration,
        enhance_prompt: true,
      };

      if (imageGcsUri) {
        request.image_gcs_uri = imageGcsUri;
      }

      let response: Response;
      if (model === 'Veo 3.1') {
        request.model = 'VEO_3_1';
        request.output_resolution = '720p';
        request.generate_audio = true;
        
        response = mode === 'Text-to-Video' 
          ? await triggerVeo3TextToVideo(request)
          : await triggerVeo3ImageToVideo(request);
      } else {
        response = mode === 'Text-to-Video'
          ? await triggerVeo2TextToVideo(request)
          : await triggerVeo2ImageToVideo(request);
      }

      if (!response.ok) {
        throw new Error(`Failed to start generation: ${response.statusText}`);
      }

      const reader = response.body?.getReader();
      if (!reader) throw new Error('No response body');

      const decoder = new TextDecoder();
      let buffer = '';

      while (true) {
        const { done, value } = await reader.read();
        if (done) break;

        buffer += decoder.decode(value, { stream: true });
        const lines = buffer.split('\n');
        buffer = lines.pop() || '';

        for (const line of lines) {
          if (line.startsWith('data: ')) {
            try {
              const data = JSON.parse(line.substring(6));
              setProgress(prev => [...prev, data]);
              
              if (data.type === 'result' && data.data?.video_url) {
                setResultVideo(data.data.video_url);
              }
              if (data.type === 'error') {
                setError(data.message);
              }
            } catch (e) {
              console.error('Error parsing SSE data', e);
            }
          }
        }
      }
    } catch (err: any) {
      setError(err.message || 'An unexpected error occurred');
    } finally {
      setIsGenerating(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-950 text-gray-100 flex flex-col font-sans">
      {/* Header */}
      <header className="border-b border-gray-800 bg-gray-900/50 backdrop-blur-md sticky top-0 z-10">
        <div className="max-w-7xl mx-auto px-4 h-16 flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="bg-blue-600 p-2 rounded-lg">
              <Video className="w-6 h-6 text-white" />
            </div>
            <h1 className="text-xl font-bold tracking-tight">Veo <span className="text-blue-500">Demo</span></h1>
          </div>
          <div className="flex items-center space-x-2 bg-gray-800 p-1 rounded-lg">
            {(['Veo 2.0', 'Veo 3.1'] as Model[]).map((m) => (
              <button
                key={m}
                onClick={() => setModel(m)}
                className={`px-3 py-1.5 rounded-md text-sm font-medium transition-all ${
                  model === m ? 'bg-blue-600 text-white shadow-lg' : 'text-gray-400 hover:text-white'
                }`}
              >
                {m}
              </button>
            ))}
          </div>
        </div>
      </header>

      <main className="flex-1 max-w-7xl mx-auto w-full p-6 flex flex-col lg:flex-row gap-8">
        {/* Left Sidebar - Controls */}
        <div className="w-full lg:w-96 flex flex-col gap-6">
          <div className="bg-gray-900 rounded-xl border border-gray-800 p-6 shadow-xl">
            <h2 className="text-lg font-semibold mb-4 flex items-center">
              <Settings className="w-5 h-5 mr-2 text-blue-500" />
              Configuration
            </h2>

            <div className="space-y-5">
              {/* Mode Selection */}
              <div>
                <label className="block text-sm font-medium text-gray-400 mb-2">Generation Mode</label>
                <div className="grid grid-cols-2 gap-2">
                  {(['Text-to-Video', 'Image-to-Video'] as Mode[]).map((m) => (
                    <button
                      key={m}
                      onClick={() => setMode(m)}
                      className={`flex items-center justify-center py-2 px-3 rounded-lg border text-sm transition-all ${
                        mode === m 
                          ? 'border-blue-500 bg-blue-500/10 text-blue-400' 
                          : 'border-gray-700 bg-gray-800 text-gray-400 hover:border-gray-600'
                      }`}
                    >
                      {m === 'Text-to-Video' ? <Video className="w-4 h-4 mr-2" /> : <ImageIcon className="w-4 h-4 mr-2" />}
                      {m.split('-')[0]}
                    </button>
                  ))}
                </div>
              </div>

              {/* Image Upload for Image-to-Video */}
              {mode === 'Image-to-Video' && (
                <div className="animate-in fade-in slide-in-from-top-2 duration-300">
                  <label className="block text-sm font-medium text-gray-400 mb-2">Reference Image</label>
                  <div 
                    onClick={() => document.getElementById('image-upload')?.click()}
                    className={`relative aspect-video rounded-lg border-2 border-dashed flex flex-col items-center justify-center cursor-pointer transition-all ${
                      imagePreview ? 'border-blue-500/50' : 'border-gray-700 hover:border-gray-600 bg-gray-800/50'
                    }`}
                  >
                    {imagePreview ? (
                      <img src={imagePreview} className="w-full h-full object-cover rounded-lg" alt="Preview" />
                    ) : (
                      <>
                        <Upload className="w-8 h-8 text-gray-500 mb-2" />
                        <span className="text-xs text-gray-400 text-center px-4">Click to upload or drag & drop</span>
                      </>
                    )}
                    <input id="image-upload" type="file" className="hidden" onChange={handleImageChange} accept="image/*" />
                  </div>
                </div>
              )}

              {/* Prompt */}
              <div>
                <label className="block text-sm font-medium text-gray-400 mb-2">Prompt</label>
                <textarea
                  value={prompt}
                  onChange={(e) => setPrompt(e.target.value)}
                  placeholder="A cinematic shot of a sunset over the mountains..."
                  className="w-full bg-gray-800 border border-gray-700 rounded-lg p-3 text-sm focus:ring-2 focus:ring-blue-500 focus:border-transparent outline-none min-h-[100px] resize-none"
                />
              </div>

              {/* Advanced Parameters */}
              <div className="pt-4 border-t border-gray-800">
                <div className="flex items-center justify-between mb-4">
                  <h3 className="text-sm font-medium text-gray-300">Advanced Parameters</h3>
                  <Layers className="w-4 h-4 text-gray-500" />
                </div>
                
                <div className="space-y-4">
                  <div>
                    <div className="flex justify-between mb-1">
                      <label className="text-xs text-gray-400">Aspect Ratio</label>
                      <span className="text-xs text-blue-400 font-mono">{aspectRatio}</span>
                    </div>
                    <select 
                      value={aspectRatio}
                      onChange={(e) => setAspectRatio(e.target.value)}
                      className="w-full bg-gray-800 border border-gray-700 rounded-lg p-2 text-xs outline-none"
                    >
                      <option value="16:9">16:9 (Landscape)</option>
                      <option value="9:16">9:16 (Portrait)</option>
                      <option value="1:1">1:1 (Square)</option>
                      <option value="4:3">4:3 (Classic)</option>
                    </select>
                  </div>

                  {model === 'Veo 3.1' && (
                    <div>
                      <div className="flex justify-between mb-1">
                        <label className="text-xs text-gray-400">Duration (seconds)</label>
                        <span className="text-xs text-blue-400 font-mono">{duration}s</span>
                      </div>
                      <input 
                        type="range" 
                        min="2" 
                        max="10" 
                        step="1"
                        value={duration}
                        onChange={(e) => setDuration(parseInt(e.target.value))}
                        className="w-full accent-blue-500"
                      />
                    </div>
                  )}

                  <div>
                    <label className="text-xs text-gray-400 block mb-1">Negative Prompt</label>
                    <input 
                      type="text"
                      value={negativePrompt}
                      onChange={(e) => setNegativePrompt(e.target.value)}
                      placeholder="Blurry, low quality, distorted..."
                      className="w-full bg-gray-800 border border-gray-700 rounded-lg p-2 text-xs outline-none"
                    />
                  </div>
                </div>
              </div>

              <button
                disabled={isGenerating || !prompt || (mode === 'Image-to-Video' && !selectedImage)}
                onClick={handleGenerate}
                className={`w-full py-3 rounded-lg font-bold flex items-center justify-center transition-all ${
                  isGenerating || !prompt || (mode === 'Image-to-Video' && !selectedImage)
                    ? 'bg-gray-800 text-gray-500 cursor-not-allowed'
                    : 'bg-blue-600 hover:bg-blue-500 text-white shadow-lg shadow-blue-900/20 active:scale-95'
                }`}
              >
                {isGenerating ? (
                  <>
                    <Loader2 className="w-5 h-5 mr-2 animate-spin" />
                    Generating...
                  </>
                ) : (
                  <>
                    <Play className="w-5 h-5 mr-2 fill-current" />
                    Generate Video
                  </>
                )}
              </button>
            </div>
          </div>
        </div>

        {/* Right Content - Results & Progress */}
        <div className="flex-1 flex flex-col gap-6 min-h-[600px]">
          {/* Result Area */}
          <div className="bg-gray-900 rounded-xl border border-gray-800 flex-1 overflow-hidden flex flex-col shadow-xl">
            <div className="px-6 py-4 border-b border-gray-800 flex items-center justify-between">
              <h2 className="text-lg font-semibold">Output Preview</h2>
              {resultVideo && (
                <a 
                  href={resultVideo} 
                  download 
                  className="flex items-center text-sm text-blue-400 hover:text-blue-300 transition-colors"
                >
                  <Download className="w-4 h-4 mr-1" />
                  Download
                </a>
              )}
            </div>

            <div className="flex-1 relative bg-black flex items-center justify-center p-4">
              {resultVideo ? (
                <video 
                  src={resultVideo} 
                  controls 
                  autoPlay 
                  loop 
                  className="max-w-full max-h-full rounded-lg shadow-2xl"
                />
              ) : isGenerating ? (
                <div className="flex flex-col items-center text-gray-500">
                  <div className="relative w-20 h-20 mb-4">
                    <div className="absolute inset-0 border-4 border-blue-500/20 rounded-full"></div>
                    <div className="absolute inset-0 border-4 border-blue-500 border-t-transparent rounded-full animate-spin"></div>
                    <Video className="absolute inset-0 m-auto w-8 h-8 text-blue-500 animate-pulse" />
                  </div>
                  <p className="text-lg font-medium animate-pulse">Generation in progress...</p>
                  <p className="text-sm">This may take 1-2 minutes</p>
                </div>
              ) : (
                <div className="flex flex-col items-center text-gray-600 text-center">
                  <Video className="w-16 h-16 mb-4 opacity-20" />
                  <p className="text-lg font-medium">No video generated yet</p>
                  <p className="text-sm max-w-xs">Configure your prompt and click Generate to see the magic happen.</p>
                </div>
              )}

              {error && (
                <div className="absolute bottom-4 inset-x-4 bg-red-950/90 border border-red-500/50 p-4 rounded-lg flex items-start text-red-200 animate-in fade-in slide-in-from-bottom-2">
                  <AlertCircle className="w-5 h-5 mr-3 mt-0.5 shrink-0" />
                  <div>
                    <p className="font-bold text-sm">Error</p>
                    <p className="text-xs opacity-90">{error}</p>
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Progress / Logs */}
          <div className="bg-gray-900 rounded-xl border border-gray-800 h-64 overflow-hidden flex flex-col shadow-xl">
            <div className="px-6 py-3 border-b border-gray-800 bg-gray-800/30 flex items-center justify-between">
              <span className="text-xs font-bold uppercase tracking-widest text-gray-500">Activity Log</span>
              <span className="flex h-2 w-2 relative">
                <span className={`animate-ping absolute inline-flex h-full w-full rounded-full bg-blue-400 opacity-75 ${isGenerating ? 'block' : 'hidden'}`}></span>
                <span className={`relative inline-flex rounded-full h-2 w-2 bg-blue-500 ${isGenerating ? 'opacity-100' : 'opacity-20'}`}></span>
              </span>
            </div>
            <div 
              ref={scrollRef}
              className="flex-1 p-4 overflow-y-auto font-mono text-xs space-y-2 scroll-smooth"
            >
              {progress.length === 0 ? (
                <div className="text-gray-700 italic">Waiting for activity...</div>
              ) : (
                progress.map((msg, i) => (
                  <div key={i} className="flex items-start animate-in fade-in slide-in-from-left-1">
                    {msg.type === 'progress' && <ChevronRight className="w-3 h-3 mt-0.5 mr-2 text-blue-500" />}
                    {msg.type === 'status' && <Loader2 className="w-3 h-3 mt-0.5 mr-2 text-yellow-500 animate-spin" />}
                    {msg.type === 'result' && <CheckCircle2 className="w-3 h-3 mt-0.5 mr-2 text-green-500" />}
                    {msg.type === 'error' && <AlertCircle className="w-3 h-3 mt-0.5 mr-2 text-red-500" />}
                    <span className={`${
                      msg.type === 'error' ? 'text-red-400' : 
                      msg.type === 'result' ? 'text-green-400' : 
                      msg.type === 'status' ? 'text-yellow-400' : 
                      'text-gray-400'
                    }`}>
                      <span className="text-gray-600 mr-2">[{new Date().toLocaleTimeString()}]</span>
                      {msg.message}
                    </span>
                  </div>
                ))
              )}
            </div>
          </div>
        </div>
      </main>

      <footer className="border-t border-gray-800 py-6 bg-gray-900/30">
        <div className="max-w-7xl mx-auto px-4 text-center text-gray-500 text-sm">
          <p>© 2026 Accelerated Platforms. Powered by Google Veo & ComfyUI.</p>
        </div>
      </footer>
    </div>
  );
}

export default App;
